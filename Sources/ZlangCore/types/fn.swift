// enum ValueError {
//     case notUsed
//     case notChanged
//     case notInitialized
//     case changedConst
// }

// class Value {
//     var name: String
//     var isStatic: Bool
//     var isUsed: Bool
//     var isPub: Bool
//     var isVar: Bool
//     var isInitialized: Bool
//     var isChanged: Bool
//     var isType: Bool
//     var access: Access

//     init(_ name: String) {
//         self.isStatic = false
//         self.isUsed = false
//         self.isPub = false
//         self.isVar = false
//         self.isChanged = false
//         self.isType = false
//         self.isInitialized = false
//         self.access = ._internal
//         self.name = name
//     }

//     convenience init(_ name: String, _ isType: Bool) {
//         self.init(name)
//         self.isType = isType
//     }

//     convenience init(_ name: String, _ isType: Bool, _ isPub: Bool) {
//         self.init(name, isType)
//         self.isPub = isPub
//     }

//     init(_ name: String, _ isType: Bool, _ isPub: Bool, _ access: Access) {
//         self.isStatic = false
//         self.isUsed = false
//         self.isPub = isPub
//         self.isVar = false
//         self.isInitialized = false
//         self.isChanged = false
//         self.isType = isType
//         self.access = access
//         self.name = name
//     }

//     func check() -> ValueError? {
//         if !isUsed {
//             return .notUsed
//         }
//         if isVar && !isChanged {
//             return .notChanged
//         }
//         if !isVar && isChanged {
//             return .changedConst
//         }
//         return nil

//     }

//     func str() -> String {
//         return name
//     }
// }

// class Fns: Value {
//     var fns: [Int:Fn]

//     override init(_ name: String) {
//         fns = [:]
//         super.init(name)
//     }

//     func contains(_ fn: Fn) -> Bool {
//         return fns[fn.signature] != nil
//     }

//     func insert(_ fn: Fn) {
//         fns[fn.signature] = fn
//     }
// }

// class GenericType {
//     var symbol: String
//     var interface: [String]

//     init(_ symbol: String, _ interface: [String] = []) {
//         self.symbol = symbol
//         self.interface = interface
//     }
// }

// class Fn: Value, Equatable, Hashable {
//     var args: [Arg] = []
//     var returns: [Arg] = []

//     var isGeneric: Bool = false
//     var genericTypes: [GenericType]? = nil

//     static func ==(_ my: Fn, _ other: Fn) -> Bool {
//         return my.returns == other.returns && my.args == other.args
//     }

//     func hash(into hasher: inout Hasher) {
//         hasher.combine(name)
//         for arg in args {
//             hasher.combine(arg)
//         }
//         for arg in returns {
//             hasher.combine(arg)
//         }
//     }

//     lazy var signature: Int = { () -> Int in
//         var hasher = Hasher()
//         self.hash(into: &hasher)
//         return hasher.finalize()
//     }()

//     override func str() -> String {
//         return "Fn(\(name))"
//     }

// }

// class Arg: Equatable, Hashable {
//     var name: String = ""
//     var isVar: Bool = false
//     var type: Type = Type()!

//     static func ==(_ my: Arg, _ other: Arg) -> Bool {
//         return my.name == other.name && my.type == other.type
//     }

//     func hash(into hasher: inout Hasher) {
//         hasher.combine(name)
//         hasher.combine(isVar)
//         hasher.combine(type)
//     }

//     func str() -> String {
//         return type.str()
//     }
// }

// class Var: Value, Equatable {
//     var typ: Type
//     var let: Bool { !isVar }
//     var tableForType: TableForType? = nil
//     var tableForVar: TableForType? = nil

//     override init(_ name: String) {
//         self.typ = Type()!
//         super.init(name)
//     }

//     convenience init(_ type: Type, _ name: String, _ table: TableForType) {
//         self.init(type, name)
//         self.tableForType = table
//     }

//     convenience init(_ type: Type, _ name: String) {
//         self.init(name)
//         self.typ = type
//     }

//     init(_ type: Type, _ name: String, _ isType: Bool, _ isPub: Bool, _ access: Access) {
//         self.typ = type
//         super.init(name, isType, isPub, access)
//     }

//     init(_ type: Type, _ name: String, _ isType: Bool, _ isPub: Bool, _ access: Access, _ table: TableForType) {
//         self.typ = type
//         self.tableForType = table
//         super.init(name, isType, isPub, access)
//         if isType {
//             self.tableForVar = TableForType()
//         }
//     }

//     func setTableForType(_ table: TableForType) {
//         self.tableForType = table
//     }

//     func add(_ value: Value) {
//         tableForType!.register(value)
//     }

//     static func ==(_ left: Var, _ right: Var) -> Bool {
//         return left.typ == right.typ && left.name == right.name &&
//             left.isVar == right.isVar && left.isStatic == right.isStatic &&
//             left.isType == right.isType
//     }

//     func type() -> String {
//         return typ.str()
//     }

//     func getTypeName() -> String {
//         if isType {
//             return name
//         }
//         return "type_" + name
//     }

//     override func str() -> String {
//         return "Var(\(name))"
//     }
// }

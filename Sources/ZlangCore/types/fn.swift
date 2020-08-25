
class Value {
    var name: String
    var isStatic: Bool
    var access: Access

    init(_ name: String) {
        self.isStatic = false
        self.access = ._internal
        self.name = name
    }

    func str() -> String {
        return name
    }
}

class Fns: Value {
    var fns: [Int:Fn]

    override init(_ name: String) {
        fns = [:]
        super.init(name)
    }

    func contains(_ fn: Fn) -> Bool {
        return fns[fn.signature] != nil
    }

    func insert(_ fn: Fn) {
        fns[fn.signature] = fn
    }
}

class GenericType {
    var symbol: String
    var interface: [String]

    init(_ symbol: String, _ interface: [String] = []) {
        self.symbol = symbol
        self.interface = interface
    }
}

class Fn: Value, Equatable, Hashable {
    var args: [Arg] = []
    var returns: [Arg] = []

    var isGeneric: Bool = false
    var genericTypes: [GenericType]? = nil

    static func ==(_ my: Fn, _ other: Fn) -> Bool {
        return my.returns == other.returns && my.args == other.args
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        for arg in args {
            hasher.combine(arg)
        }
        for arg in returns {
            hasher.combine(arg)
        }
    }

    lazy var signature: Int = { () -> Int in
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }()
    
}

class Arg: Equatable, Hashable {
    var name: String = ""
    var isVar: Bool = false
    var type: Type = Type()!

    static func ==(_ my: Arg, _ other: Arg) -> Bool {
        return my.name == other.name && my.type == other.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(isVar)
        hasher.combine(type)
    }

    func str() -> String {
        return type.str()
    }
}

class Var: Value, Equatable {
    var typ: Type
    var isVar: Bool
    var isType: Bool
    var relatedTypeSymbol: TableForType?
    var relatedTypeTypeSymbol: TableForType?

    var const: Bool { !isVar }

    override init(_ name: String) {
        self.typ = Type()!
        self.isVar = false
        self.isType = false
        self.relatedTypeSymbol = nil
        self.relatedTypeTypeSymbol = nil
        super.init(name)
    }

    convenience init(_ type: Type, _ name: String, _ isVar: Bool) {
        self.init(name)
        self.typ = type
        self.isVar = isVar
    }

    static func ==(_ left: Var, _ right: Var) -> Bool {
        return left.typ == right.typ && left.name == right.name &&
            left.isVar == right.isVar && left.isStatic == right.isStatic &&
            left.isType == right.isType
    }

    func type() -> String {
        if let rs = relatedTypeSymbol {
            return typ.str() + " " + rs.type()
        }
        return typ.str()
    }
}


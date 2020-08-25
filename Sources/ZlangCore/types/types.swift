enum Type: String {
  case unknown = "unknown"
  case _nil = "nil"
  case int8 = "int8"
  case int16 = "int16"
  case int32 = "int32"
  case int64 = "int64"
  case int = "int"
  case uint8 = "uint8"
  case uint16 = "uint16"
  case uint32 = "uint32"
  case uint64 = "uint64"
  case uint = "uint"
  case char = "char"
  case float = "float"
  case double = "double"
  case string = "string"
  case bool = "bool"
  case list = "list"
  case dict = "dict"
  case _set = "set"
  case _struct = "struct"
  case _enum = "enum"
  case tuple = "tuple"
  case function = "fn"
  case alias = "alias"
  case comment = "comment"

  init?() {
    self.init(rawValue: "unknown")
  }

  static let signedIntegers: [Type] = [.int8, .int16, .int32, .int64, .int]
  static let unsignedIntegers: [Type] = [.uint8, .uint16, .uint32, .uint64, .uint]
  static let floats: [Type] = [.float, .double]

  func isSigned() -> Bool {
    return Type.signedIntegers.contains(self)
  }

  func isUnsigned() -> Bool {
    return Type.unsignedIntegers.contains(self)
  }

  func isFloat() -> Bool {
    return Type.floats.contains(self)
  }

  func isInteger() -> Bool {
    return isSigned() || isUnsigned()
  }

  func isString() -> Bool {
    return self == .string
  }

  func isFunction() -> Bool {
    return self == .function
  }

  func isEnum() -> Bool {
    return self == ._enum
  }

  func isStruct() -> Bool {
    return self == ._struct
  }

  func isList() -> Bool {
    return self == .list
  }

  func isDict() -> Bool {
    return self == .dict
  }

  func isSet() -> Bool {
    return self == ._set
  }

  func isTuple() -> Bool {
    return self == .tuple
  }

  func isAlias() -> Bool {
    return self == .alias
  }

  func isComment() -> Bool {
      return self == .comment
  }

  func str() -> String {
    return self.rawValue
  }
}

// class Type: Equatable, Hashable {
//   var type: BasicType
//   var typeSymbol: String
//   var isType: Bool

//   init() {
//     self.type = BasicType()!
//     self.typeSymbol = ""
//     self.isType = false
//   }

//   init(_ type: BasicType, _ typeSymbol: String, _ isType: Bool = false) {
//     self.type = type
//     self.isType = isType
//     self.typeSymbol = typeSymbol
//   }

//   static func ==(_ left: Type, _ right: Type) -> Bool {
//     return left.typeSymbol == right.typeSymbol
//   }

//   func str() -> String {
//     return type.rawValue
//   }

//   func hash(into hasher: inout Hasher) {
//       hasher.combine(type)
//       hasher.combine(typeSymbol)
//   }

// }

// class TypeSymbol: Equatable {
//   var name: String
//   var kind: Type
//   var info: TypeInfo
//   var parent: String
//   var methods: [String: Fn]
//   var vars: [String: Var]

//   var isType: Bool { return kind.isType }
//   var access: Access
//   var mod: String

//   init() {
//       self.name = ""
//       self.kind = Type()
//       self.mod = ""
//       self.parent = ""
//       self.info = TypeInfo()
//       self.methods = [:]
//       self.vars = [:]
//       self.access = ._internal
//   }

//   convenience init(name: String, kind: Type, _ parent: String) {
//     self.init()
//     self.name = name
//     self.parent = parent
//     self.kind = kind
//   }

//   static func ==(_ left: TypeSymbol, _ right: TypeSymbol) -> Bool {
//     return (left.name, left.kind) == (right.name, right.kind)
//   }

//   func addMethod(_ fn: Fn) {
//     if hasMethod(fn) {
//         fatalError("duplicated fn \(fn)")
//     }
//     methods[fn.signature] = fn
//   }

//   func hasMethod(_ fn: Fn) -> Bool {
//     return methods[fn.signature] != nil
//   }

//   func addVar(_ _var: Var) {
//     if hasVar(_var) {
//       fatalError("duplicated var \(_var)")
//     }
//     vars[_var.name] = _var
//   }

//   func hasVar(_ _var: Var) -> Bool {
//     return vars[_var.name] != nil
//   }

//   func conformToInterface(_ interface: Interface) -> Bool {
//     return false
//   }

//   func type() -> Type {
//       return kind
//   }
// }
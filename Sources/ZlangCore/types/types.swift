public enum Type: String {
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

class TypeSymbol {
  var name: String
  var kind: Type
  var isOptional: Bool = false
  var isGeneric: Bool = false
  var genericTypes: [TypeSymbol]? = nil
  var staticMethods: [String: [String: Fn]] = [:]
  var instanceMethods: [String: [String: Fn]] = [:]
  var staticVars: [String: Var] = [:]
  var instanceVars: [String: Var] = [:]
  var interfaces: [String: Interface] = [:]

  var mod: String
  var access: Access

  init() {
      self.name = ""
      self.kind = ""
      self.mod = ""
      self.access = ._internal
  }

  init(name: String, kind: Type, mod: String) {
    self.name = name
    self.kind = kind
    self.mod = mod
    self.access = ._internal
  }

  func addStaticMethod(_ fn: Fn) {
      assert(fn.isStatic, "invalid static function")
  }

  func type() -> Type {
      return kind
  }
}
public enum Type: String {
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

class TypeSymbol: Equatable {
  var name: String
  var kind: Type
  var isOptional: Bool = false
  var isGeneric: Bool = false
  var genericTypes: [TypeSymbol]? = nil
  var staticMethods: [String: Set<Fn>] = [:]
  var instanceMethods: [String: Set<Fn>] = [:]
  var staticVars: [String: Var] = [:]
  var instanceVars: [String: Var] = [:]
  var interfaces: [String: Interface] = [:]

  var access: Access
  var mod: String

  init() {
      self.name = ""
      self.kind = Type()!
      self.mod = ""
      self.access = ._internal
  }

  convenience init(name: String, kind: Type) {
    self.init()
    self.name = name
    self.kind = kind
  }

  static func ==(_ left: TypeSymbol, _ right: TypeSymbol) -> Bool {
    return (left.name, left.kind, left.isOptional) == (right.name, right.kind, right.isOptional)
  }

  func addStaticMethod(_ fn: Fn) {
      assert(fn.isStatic, "invalid static function")
      if hasStaticMethod(fn) {
        fatalError("duplicated fn \(fn)")
      }
      if staticMethods[fn.name] == nil {
        staticMethods[fn.name] = Set<Fn>()
      }
      staticMethods[fn.name]!.insert(fn)
  }

  func addInstanceMethod(_ fn: Fn) {
    assert(!fn.isStatic, "invalid instance method")
    if hasInstanceMethod(fn) {
      fatalError("duplicated fn \(fn)")
    }
    if instanceMethods[fn.name] == nil {
      instanceMethods[fn.name] = Set<Fn>()
    }

    instanceMethods[fn.name]!.insert(fn)
  }

  func hasStaticMethod(_ fn: Fn) -> Bool {
    assert(fn.isStatic, "invalid static function")
    if let fns = staticMethods[fn.name], fns.contains(fn) {
      return true
    }
    return false
  }

  func hasInstanceMethod(_ fn: Fn) -> Bool {
    assert(!fn.isStatic, "invalid instance method")
    if let fns = instanceMethods[fn.name], fns.contains(fn) {
      return true
    }
    return false
  }

  func addStaticVar(_ _var: Var) {
    assert(_var.isStatic, "invalid static var")
    if hasStaticVar(_var) {
      fatalError("duplicated var \(_var)")
    }
    staticVars[_var.name] = _var
  }

  func addInstanceVar(_ _var: Var) {
    assert(!_var.isStatic, "invalid instance var")
    if hasInstanceVar(_var) {
      fatalError("duplicated var \(_var)")
    }
    instanceVars[_var.name] = _var
  }

  func hasStaticVar(_ _var: Var) -> Bool {
    assert(_var.isStatic, "invalid static var")
    if let vars = staticVars[_var.name], vars == _var {
      return true
    }
    return false
  }

  func hasInstanceVar(_ _var: Var) -> Bool {
    assert(!_var.isStatic, "invalid instance var")
    if let vars = instanceVars[_var.name], vars == _var {
      return true
    }
    return false
  }

  func conformToInterface(_ interface: Interface) -> Bool {
    return false
  }

  func type() -> Type {
      return kind
  }
}
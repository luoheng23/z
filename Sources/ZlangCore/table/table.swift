class TableForImportsAndModules {
  var imports: Set<String> = []
  var modules: Set<String> = []
}

class TableForType {
  var fns: [String: Fns]
  var vars: [String: Var]

  init() {
    fns = [:]
    vars = [:]
  }

  func findFn(_ name: String) -> Fns? {
    return self.fns[name]
  }

  func hasFn(_ name: String) -> Bool {
    return findFn(name) != nil
  }

  func findVar(_ name: String) -> Var? {
    return self.vars[name]
  }

  func hasVar(_ name: String) -> Bool {
    return findVar(name) != nil
  }

  func findValue(_ name: String) -> Value? {
    if let fn = findFn(name) {
      return fn
    }
    if let _var = findVar(name) {
      return _var
    }
    return nil
  }

  func registerFn(_ fn: Fn) {
    if self.fns[fn.name]?.contains(fn) != nil {
      fatalError("duplicated function \(fn.name) with \(fn.signature)")
    }
    if self.fns[fn.name] == nil {
      self.fns[fn.name] = Fns(fn.name)
    }
    self.fns[fn.name]!.insert(fn)
  }

  func registerVar(_ _var: Var) {
    if self.vars[_var.name] != nil {
      fatalError("duplicated variable \(_var.name)")
    }
    self.vars[_var.name] = _var
  }

  func register(_ val: Value) {
    if let fn = val as? Fn {
      registerFn(fn)
    } else if let _var = val as? Var {
      registerVar(_var)
    }
    fatalError("invalid type to register")
  }

  func registerBuiltinTypeSymbols() {
    let int = Var(.int, "int", true, true, ._public, TableForType())
    self.registerVar(int)
    let int8 = Var(.int8, "int8", true, true, ._public, TableForType())
    self.registerVar(int8)
    let int16 = Var(.int16, "int16", true, true, ._public, TableForType())
    self.registerVar(int16)
    let int32 = Var(.int32, "int32", true, true, ._public, TableForType())
    self.registerVar(int32)
    let int64 = Var(.int64, "int64", true, true, ._public, TableForType())
    self.registerVar(int64)
    let uint =   Var(.uint,   "uint", true, true, ._public, TableForType())
    self.registerVar(uint)
    let uint8 =  Var(.uint8,  "uint8", true, true, ._public, TableForType())
    self.registerVar(uint8)
    let uint16 = Var(.uint16, "uint16", true, true, ._public, TableForType())
    self.registerVar(uint16)
    let uint32 = Var(.uint32, "uint32", true, true, ._public, TableForType())
    self.registerVar(uint32)
    let uint64 = Var(.uint64, "uint64", true, true, ._public, TableForType())
    self.registerVar(uint64)
    let float = Var(.float, "float", true, true, ._public, TableForType())
    self.registerVar(float)
    let double = Var(.double, "double", true, true, ._public, TableForType())
    self.registerVar(double)
    let char = Var(.char, "char", true, true, ._public, TableForType())
    self.registerVar(char)
    let string = Var(.string, "string", true, true, ._public, TableForType())
    self.registerVar(string)
    let dict = Var(.dict, "dict", true, true, ._public, TableForType())
    self.registerVar(dict)
    let _set = Var(._set, "set", true, true, ._public, TableForType())
    self.registerVar(_set)
    let _struct = Var(._struct, "struct", true, true, ._public, TableForType())
    self.registerVar(_struct)
    let list = Var(.list, "list", true, true, ._public, TableForType())
    self.registerVar(list)
    let bool = Var(.bool, "bool", true, true, ._public, TableForType())
    self.registerVar(bool)
    let tuple = Var(.tuple, "tuple", true, true, ._public, TableForType())
    self.registerVar(tuple)
    let comment = Var(.comment, "comment", true, true, ._public, TableForType())
    self.registerVar(comment)
    let alias = Var(.alias, "alias", true, true, ._public, TableForType())
    self.registerVar(alias)
    let function = Var(.function, "function", true, true, ._public, TableForType())
    self.registerVar(function)
    let _nil = Var(._nil, "nil", true, true, ._public, TableForType())
    self.registerVar(_nil)
}

  func getValue(_ val: String) -> String {
    if let v = findValue(val) {
      return v.name
    }
    return val
  }
}

class TableForImportsAndModules {
  var imports: Set<String> = []
  var modules: Set<String> = []
}

class TableForType {
  var typeFunc: [String: TableForType]
  var fns: [String: Fns]
  var vars: [String: Var]
  var belongTo: Var?

  init() {
    typeFunc = [:]
    fns = [:]
    vars = [:]
    belongTo = nil
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

  func setOwner(_ owner: Var) {
      belongTo = owner
  }

  func registerBuiltinTypeSymbols() {

  }

  func getValue(_ val: String) -> String {
    if let v = findValue(val) {
      return v.name
    }
    return val
  }

  func type() -> String {
    if let belt = belongTo {
      return belt.type()
    }
    return "unknown"
  }
}

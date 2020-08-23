
enum ScopeObject {
    case const(ConstField)
    case _var(Var)
    case global(GlobalDecl)
}

class Scope {
    var parent: Scope
    var childern: [Scope]
    var objects: [String: ScopeObject]
    var startPos: Int
    var endPos: Int
    var isTopScope: Bool 

    init(parent: Scope, startPos: Int, _ isTopScope: Bool = false) {
        self.parent = parent
        self.childern = []
        self.startPos = startPos
        self.isTopScope = false
        self.endPos = 0
    }

    func findWithScope(_ name: String) -> (ScopeObject, Scope)? {
        var sc = self
        while true {
            if let c = sc.objects[name] {
                return c, sc
            }
            if sc.isTopScope {
                break
            }
            sc = sc.parent
        }
        return nil
    }

    func find(_ name: String) -> ScopeObject? {
        if let c = findWithScope(name) {
            return c.0
        }
        return nil
    }

    func has(_ name: String) -> Bool {
        return find(name) != nil
    }

    func findVar(_ name: String) -> Var? {
        if let _var = find(name), _var is Var {
            return _var
        }
        return nil
    }

    func findConst(_ name: String) -> ConstField? {
        if let _const = find(name), _const is ConstField {
            return _const
        }
        return nil
    }

    func hasVar(_ name: String) -> Bool {
        return findVar(name) != nil
    }

    func hasConst(_ name: String) -> Bool {
        return findConst(name) != nil
    }

    func updateVarType(_ name: String, _ type: Type) {
        let _var = findVar(name)
        _var.type = type
    }

    func register(_ name: String, _ obj: ScopeObject) {
        if name == "_" || has(name) {
            return
        }
        objects[name] = obj
    }

    func outermost() -> Scope {
        var sc = self
        while !sc.isTopScope {
            sc = sc.parent
        }
        return sc
    }

    func innermost(_ pos: Int) -> Scope {
        if !contains(pos) {
            return self
        }
        var (first, last) = 0, childern.count - 1
        while first <= last {
            let mid = (first + last) / 2
            let s1 = childern[mid]
            if s1.endPos < pos {
                first = mid + 1
            } else if s1.contains(pos) {
                return s1.innermost(pos)
            } else {
                last = mid - 1
            }
        }
        return self
    }

    func contains(_ pos: Int) -> Bool {
        return pos >= startPos && pos <= endPos
    }
}
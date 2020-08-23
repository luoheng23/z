
enum ScopeObject {
    case const(ConstField)
    case _var(Var)
}

class Scope {
    var parent: Scope?
    var children: [Scope]
    var objects: [String: ScopeObject]
    var pos: Position
    var isTopScope: Bool { parent == nil }

    init() {
        self.parent = nil
        self.children = []
        self.objects = [:]
        self.pos = Position()
    }

    init(parent: Scope, pos: Position, _ isTopScope: Bool = false) {
        self.parent = parent
        self.children = []
        self.objects = [:]
        self.pos = pos
    }

    func findWithScope(_ name: String) -> (ScopeObject, Scope)? {
        var sc = self
        while let s = sc.parent {
            if let c = s.objects[name] {
                return (c, s)
            }
            if s.isTopScope {
                break
            }
            sc = s.parent!
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
        if let _var = find(name) {
            switch _var {
            case ._var(let varField):
                return varField
            default:
                return nil
            }
        }
        return nil
    }

    func findConst(_ name: String) -> ConstField? {
        if let _const = find(name) {
            switch _const {
            case .const(let constField):
                return constField
            default:
                return nil
            }
        }
        return nil
    }

    func hasVar(_ name: String) -> Bool {
        return findVar(name) != nil
    }

    func hasConst(_ name: String) -> Bool {
        return findConst(name) != nil
    }

    func updateVarType(_ name: String, _ type: TypeSymbol) {
        if let _var = findVar(name) {
            _var.type = type
        }
        
    }

    func register(_ name: String, _ obj: ScopeObject) {
        if name == "_" || has(name) {
            return
        }
        objects[name] = obj
    }

    func outermost() -> Scope {
        var sc = self
        while let s = sc.parent, !s.isTopScope {
            sc = s.parent!
        }
        return sc
    }

    func innermost(_ pos: Int) -> Scope {
        if !contains(pos) {
            return self
        }
        var (first, last) = (0, children.count - 1)
        while first <= last {
            let mid = (first + last) / 2
            let s1 = children[mid]
            if s1.pos.endPos < pos {
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
        return pos >= self.pos.startPos && pos <= self.pos.endPos
    }
}

class Scope {
    var parent: Scope?
    var children: [Scope]
    var pos: Position
    var isTopScope: Bool { parent == nil }

    init(_ globalScope: Bool = false) {
        parent = nil
        children = []
        pos = Position()
        // table = TableForType()
        // if globalScope {
        //     table.registerBuiltinTypeSymbols()
        // }
    }

    convenience init(parent: Scope, pos: Position, _ isTopScope: Bool = false) {
        self.init()
        self.parent = parent
        // self.table = TableForType()
        self.pos = pos
    }

    // func findWithScope(_ name: String) -> (Value, Scope)? {
    //     var sc = self
    //     while true {
    //         if let c = sc.find(name) {
    //             return (c, sc)
    //         }
    //         if isTopScope {
    //             break
    //         }
    //         sc = sc.parent!
    //     }
    //     return nil
    // }

    // func find(_ name: String) -> Value? {
    //     return table.findValue(name)
    // }

    // func has(_ name: String) -> Bool {
    //     return find(name) != nil
    // }

    // func findVar(_ name: String) -> Var? {
    //     return table.findVar(name)
    // }

    // func hasVar(_ name: String) -> Bool {
    //     return findVar(name) != nil
    // }

    // func register(_ obj: Value) {
    //     table.register(obj)
    // }

    // func outermost() -> Scope {
    //     var sc = self
    //     while !sc.isTopScope {
    //         sc = sc.parent!
    //     }
    //     return sc
    // }

    // func innermost(_ pos: Position) -> Scope {
    //     if !contains(pos) {
    //         return self
    //     }
    //     var (first, last) = (0, children.count - 1)
    //     while first <= last {
    //         let mid = (first + last) / 2
    //         let s1 = children[mid]
    //         if !s1.pos.isLeft(pos) {
    //             first = mid + 1
    //         } else if s1.contains(pos) {
    //             return s1.innermost(pos)
    //         } else {
    //             last = mid - 1
    //         }
    //     }
    //     return self
    // }

    // func contains(_ pos: Position) -> Bool {
    //     return self.pos.contains(pos)
    // }
}
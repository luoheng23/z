
class Fn: Equatable, Hashable {
    var args: [Arg] = []
    var returns: Type = ._nil
    var isGeneric: Bool = false
    var genericTypes: [TypeSymbol]? = nil
    var isStatic: Bool = false
    var belongTo: TypeSymbol = TypeSymbol()
    var access: Access = ._internal
    var name: String = ""

    init() {}

    static func ==(_ my: Fn, _ other: Fn) -> Bool {
        return my.returns == other.returns && my.args == other.args
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        for arg in args {
            hasher.combine(arg)
        }
    }
}

class Arg: Equatable, Hashable {
    var name: String = ""
    var isVar: Bool = false
    var type: Type = ._nil

    static func ==(_ my: Arg, _ other: Arg) -> Bool {
        return my.name == other.name && my.type == other.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(isVar)
        hasher.combine(type)
    }
}

class Var: Equatable {
    var type: TypeSymbol
    var name: String
    var isVar: Bool
    var isStatic: Bool

    init(_ type: TypeSymbol, _ name: String, _ isVar: Bool) {
        self.type = type
        self.name = name
        self.isVar = isVar
        self.isStatic = false
    }

    static func ==(_ left: Var, _ right: Var) -> Bool {
        return left.type == right.type && left.name == right.name &&
            left.isVar == right.isVar && left.isStatic == right.isStatic
    }
}


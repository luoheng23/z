
class Fn: Equatable {
    var args: [Arg] = []
    var returns: Type = ._nil
    var isGeneric: Bool = false
    var genericTypes: [TypeSymbol]? = nil
    var isStatic: Bool = false
    var belongTo: TypeSymbol
    var access: Access = ._internal
    var name: String = ""

    static func ==(_ my: Fn, _ other: Fn) -> Bool {
        return my.returns == other.returns && my.args == other.args
    }
}

class Arg: Equatable {
    var name: String = ""
    var isVar: Bool = false
    var type: Type = ._nil

    static func ==(_ my: Arg, _ other: Arg) -> Bool {
        return my.name == other.name && my.type == other.type
    }
}

class Var {
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
}



class EnumCase {
    var associateType: Type?
    var name: String
    var rawValue: String

    init(_ name: String, _ rawValue: String = "") {
        self.name = name
        self.rawValue = rawValue == "" ? name : rawValue
        self.associateType = nil
    }

    convenience init(_ name: String, _ rawValue: String = "", _ type: Type) {
        self.init(name, rawValue)
        self.associateType = type
    }
}

class Enum: TypeSymbol {
    var cases: [EnumCase] = []
}

class Alias: TypeSymbol {
    var parentType: TypeSymbol
    var name: String

    init(_ name: String, _ type: TypeSymbol) {
        super.init()
        self.name = name
        self.parentType = type
    }

    override func type() -> Type {
        return parentType.type()
    }
}

class Struct {
    var fields: [Field] = []
    var fns: [Fn] = []
}

class Field {
    var name: String = ""
    var type: Type = ._nil
    var defaultExpr: Bool = false
    var hasDefaultExpr: Bool = false
    var defaultVal: String = ""
    var access: Access = ._internal
    var isVar: Bool = false
    var isGlobal: Bool = false
}

class List {
    var dims: Int = 0
    var size: Int = 0
    var elemType: Type = ._nil
}

class Dict {
    var key_type: Type = ._nil
    var value_type: Type = ._nil
}

class Interface {
    var types: [Type] = []
}

class Tuple {
    var types: [Type] = []
}

class Comment {}

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

class Struct: TypeSymbol {}

class List: TypeSymbol {
    var dims: Int = 0
    var size: Int = 0
    var elemType: Type = ._nil
}

class Dict: TypeSymbol {
    var key_type: Type = ._nil
    var value_type: Type = ._nil
}

class Interface: TypeSymbol {
    var types: [Type] = []
}

class Tuple: TypeSymbol {
    var types: [Type] = []
}

class Comment: TypeSymbol {}
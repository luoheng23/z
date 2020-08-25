
class TypeInfo {}

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

class Enum: TableForType {
    var cases: [EnumCase] = []
}

class Alias: TableForType {
    var parentType: TableForType

    init(_ name: String, _ type: TableForType) {
        self.parentType = type
        super.init()
        // self.name = name
    }

    override func type() -> String {
        return parentType.type()
    }
}

class Struct: TableForType {}

class List: TableForType {
    var dims: Int = 0
    var size: Int = 0
}

class Dict: TableForType {
}

class Interface: TableForType {
    var types: [Type] = []
}
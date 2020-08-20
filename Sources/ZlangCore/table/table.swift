
class Table {
    var typeDict: [String: String]
    var consts: Array<String>
    
    func register(_ from: String, _ to: String) {
        typeDict[from] = to
    }

    init() {
        typeDict = [
            "const": "let",
            "fn": "func",
            "int": "Int",
            "int8": "Int8",
            "int16": "Int16",
            "int32": "Int32",
            "int64": "Int64",
            "uint":   "UInt",
            "uint8":  "UInt8",
            "uint16": "UInt16",
            "uint32": "UInt32",
            "uint64": "UInt64",
            "double": "Double",
            "float": "Float",
            "char": "Character",
            "str": "String",
            "extend": "extension",
            "interface": "protocol",
            "mut": "mutating",
        ]
        consts = []
    }

    func getValue(_ from: String) -> String {
        return typeDict[from] ?? from
    }
}
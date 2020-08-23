
class Table {
    var types: [String: TypeSymbol]
    var fns: Dictionary<String, Fn>
    var imports: [String]
    var modules: [String]

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
        types = [:]
        fns = [:]
        imports = []
        modules = []
    }

    func getValue(_ from: String) -> String {
        return typeDict[from] ?? from
    }

    func findFn(_ name: String) -> Fn? {
        return self.fns[name]
    }

    func hasFn(_ name: String) -> Bool {
        return findFn(name) != nil
    }

    func registerFn(_ fn: Fn) {
        self.fns[fn.name] = fn
    }

    func registerBuiltinTypeSymbols() {
        
    }
}

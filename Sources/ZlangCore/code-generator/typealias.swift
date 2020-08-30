

typealias int = Int
typealias int8 = Int8
typealias int16 = Int16
typealias int32 = Int32
typealias int64 = Int64
typealias uint =   UInt
typealias uint8 =  UInt8
typealias uint16 = UInt16
typealias uint32 = UInt32
typealias uint64 = UInt64
typealias float = Float
typealias double = Double
typealias char = Character
typealias string = String
typealias list = Array
typealias dict = Dictionary

let keyword = [
    "impl": "extension",
    "interface": "protocol",
    "fn": "func",
]

extension String {
    func getSwiftKeyword() -> String {
        if let word = keyword[self] {
            return word
        }
        return self
    }
}
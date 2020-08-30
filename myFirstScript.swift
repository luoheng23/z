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

let a = 20
var  b = 30
print(a + b)
func hello(_ word: int, _ big: int) -> int {
    print("Hello world")
    return word + big
}
print(hello(3, 4))
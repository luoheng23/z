
let a = 20
var b = 30
print(a + b)

@discardableResult
func hello(word: Int, big: Int) -> Int {
    print("Hello world")
    return word + big
}

hello(word: 3, big: 4)
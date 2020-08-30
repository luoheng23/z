
let keyword = [
    "impl": "extension",
    "interface": "protocol",
    "fn": "func",
    "const": "let",
]

extension String {
    func getSwiftKeyword() -> String {
        if let word = keyword[self.trimmingCharacters(in: .whitespacesAndNewlines)] {
            return word
        }
        return self
    }
}
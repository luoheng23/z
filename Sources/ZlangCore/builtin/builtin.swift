import Foundation

let keyword = [
  "impl": "extension",
  "interface": "protocol",
  "fn": "func",
  "let": "let",
]

precedencegroup powOperator {
  higherThan: BitwiseShiftPrecedence
  associativity: left
  assignment: true
}

infix operator **: powOperator

func ** (num: Decimal, power: Int) -> Decimal {
  return pow(num, power)
}

func ** (num: Double, power: Double) -> Double {
  return pow(num, power)
}

func ** (num: Float, power: Float) -> Float {
  return pow(num, power)
}

extension String {
  func getSwiftKeyword() -> String {
    if let word = keyword[self.trimmingCharacters(in: .whitespacesAndNewlines)] {
      return word
    }
    return self
  }
}

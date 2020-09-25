// Copyright (c) 2019 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

class Token {
  var kind: Kind
  var lit: String
  var pos: Position

  init() {
    self.kind = Kind()!
    self.lit = ""
    self.pos = Position()
  }

  init(kind: Kind, lit: String, pos: Position) {
    self.kind = kind
    self.lit = lit
    self.pos = pos
  }

  func str() -> String {
    return "\(kind.str()) '\(lit)'"
  }

  func text() -> String {
    return "\(lit)"
  }

  func isScalar() -> Bool {
    return [Kind.name, Kind.string].contains(kind)
  }

  func isUnary() -> Bool {
    return [Kind.plus, .minus, .key_not, .bit_not, .amp].contains(kind)
  }

  func isRelational() -> Bool {
    return [Kind.lt, .le, .gt, .ge, .eq, .ne].contains(kind)
  }

  func isStartOfType() -> Bool {
    return [Kind.name, .lpar, .amp, .lsbr].contains(kind)
  }

  func isInfix() -> Bool {
    return [
      Kind.plus, .minus, .mod, .mul, .div, .pow, .eq, .ne, .gt, .lt, .key_in,
      .key_not_in, .key_is, .key_is_not, .ge, .le, .key_or, .xor, .key_and, .pipe, .amp,
      .left_shift, .right_shift,
    ].contains(kind)
  }

  func isKeyword() -> Bool {
    return Kind.isKeyword(kind.rawValue)
  }

  func isDecl() -> Bool {
    return Kind.Decls.contains(kind)
  }

  func isAssign() -> Bool {
    return Kind.Assigns.contains(kind)
  }

  func isFunction() -> Bool {
    return isKind(.key_func)
  }

  func isKind(_ kind: Kind) -> Bool {
    return self.kind == kind
  }

  func isNotKind(_ kind: Kind) -> Bool {
    return !isKind(kind)
  }

  func precedence() -> Int {
    return Precedence.getPrecedence(kind).rawValue
  }
}

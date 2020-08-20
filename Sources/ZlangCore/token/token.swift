// Copyright (c) 2019 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

public class Token {
  public var kind: Kind
  public var lit: String
  public var pos: Position
  public var tidx: Int

  public init(kind: Kind, lit: String, pos: Position, tidx: Int) {
    self.kind = kind
    self.lit = lit
    self.pos = pos
    self.tidx = tidx
  }

  public func str() -> String {
    return "\(kind.str()) '\(lit)'"
  }

  public func precedence() -> Precedence {
    return Precedence.getPrecedence(kind)
  }

  public func isScalar() -> Bool {
    return [Kind.name, Kind.string].contains(kind)
  }

  public func isUnary() -> Bool {
    return [Kind.plus, .minus, .key_not, .bit_not, .amp].contains(kind)
  }

  public func isRelational() -> Bool {
    return [Kind.lt, .le, .gt, .ge, .eq, .ne].contains(kind)
  }

  public func isStartOfType() -> Bool {
    return [Kind.name, .lpar, .amp, .lsbr].contains(kind)
  }

  public func isInfix() -> Bool {
    return [Kind.plus, .minus, .mod, .mul, .div, .pow, .eq, .ne, .gt, .lt, .key_in,
      .key_not_in, .key_is, .key_is_not, .ge, .le, .key_or, .xor, .key_and, .dot, .pipe, .amp,
      .left_shift, .right_shift].contains(kind)
  }

  public func isKeyword() -> Bool {
    return Kind.isKeyword(kind.rawValue)
  }

  public func isDecl() -> Bool {
    return Kind.Decls.contains(kind)
  }

  public func isAssign() -> Bool {
    return Kind.Assigns.contains(kind)
  }

  public func isFunction() -> Bool {
    return isKind(.key_func)
  }

  public func isKind(_ kind: Kind) -> Bool {
    return self.kind == kind
  }

  public func isNotKind(_ kind: Kind) -> Bool {
    return !isKind(kind)
  }
}


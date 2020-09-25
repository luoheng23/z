extension Scanner {
  func scanNumber() -> String {
    if expect(want: Character.prefixHex, startPos: pos) {
      return hexNum()
    }
    if expect(want: Character.prefixOct, startPos: pos) {
      return octNum()
    }
    if expect(want: Character.prefixBin, startPos: pos) {
      return binNum()
    }
    return decNum()
  }

  func hexNum() -> String {
    return _num(prefixStr: Character.prefixHex, exponent: Character.hexExp)
  }

  func octNum() -> String {
    return _num(prefixStr: Character.prefixOct, exponent: Character.octExp)
  }

  func decNum() -> String {
    return _num(prefixStr: Character.prefixDec, exponent: Character.decExp)
  }

  func binNum() -> String {
    return _num(prefixStr: Character.prefixBin, exponent: Character.binExp)
  }

  func _numIntegerPart(prefixStr: String) {
    var isUnderScore = false
    while true {
      if let c = peek(), c.isDigit(prefixStr) || isUnderScore && c.isUnderScore() {
        isUnderScore = c.isDigit(prefixStr)
        nextPos()
      } else {
        break
      }
    }

    if !isUnderScore {
      error("failed to parse integer \(peek() ?? Character(""))")
    }
  }

  func _num(prefixStr: String, exponent: String) -> String {
    let start = pos
    pos = index(pos: pos, after: prefixStr.count)
    _numIntegerPart(prefixStr: prefixStr)
    // scan fractional part
    if let c = peek(), let c2 = nextPeek(), c == "." && c2.isDigit(prefixStr) {
      nextPos()
      _numIntegerPart(prefixStr: prefixStr)
    }
    // scan exponential part
    if expect(want: exponent.lowercased(), startPos: pos)
      || expect(want: exponent.uppercased(), startPos: pos)
    {
      nextPos()
      if let c = peek(), ["+", "-"].contains(c) {
        nextPos()
      }
      _numIntegerPart(prefixStr: prefixStr)
    }
    return getTokenString(start)
  }
}
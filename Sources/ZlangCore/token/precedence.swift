public enum Precedence: Int {
    case lowest = 0
    case question
    case cond_or  // or
    case cond_and  // and
    case assign  // =
    case eq  // == !=
    case range
    case sum  // + - | ^
    case product  // * / << >> & %
    case pref  // -X not X
    case index  // array[index]

    public static let prec: [Kind: Precedence] = [
        .lsbr: .index,
        .lpar: .index,
        .range: .range,
        .halfRange: .range,
        .question: .question,
        .dot: .index,
        .mul: .product,
        .div: .product,
        .mod: .product,
        .left_shift: .product,
        .right_shift: .product,
        .pow: .pref,
        .amp: .product,
        .plus: .sum,
        .minus: .sum,
        .pipe: .sum,
        .xor: .sum,
        .eq: .eq,
        .ne: .eq,
        .lt: .eq,
        .le: .eq,
        .gt: .eq,
        .ge: .eq,
        .assign: .assign,
        .plus_assign: .assign,
        .minus_assign: .assign,
        .div_assign: .assign,
        .mod_assign: .assign,
        .or_assign: .assign,
        .and_assign: .assign,
        .pow_assign: .assign,
        .left_shift_assign: .assign,
        .right_shift_assign: .assign,
        .mult_assign: .assign,
        .xor_assign: .assign,

        .key_in: .index,
        .key_is: .index,

        .key_and: .cond_and,
        .key_or: .cond_or,
    ]

    public static func getPrecedence(_ kind: Kind) -> Precedence {
        return Precedence.prec[kind] ?? .lowest
    }
}

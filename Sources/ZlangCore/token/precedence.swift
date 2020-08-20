
public enum Precedence: Int {
    case lowest = 0
    case cond_or // or
    case cond_and // and
    case in_is
    case assign // =
    case eq // == !=
    case sum // + - | ^
    case product // * / << >> & %
    case pref // -X not X
    case call // func(X) foo.method(x)
    case index // array[index]

    public static let prec: [Kind: Precedence] = [
        .lsbr: .index,
        .dot: .call,
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

        .key_in: .in_is,
        .key_is: .in_is,

        .key_and: .cond_and,
        .key_or: .cond_or,
    ]

    public static func getPrecedence(_ kind: Kind) -> Precedence {
        return  Precedence.prec[kind] ?? .lowest
    }
}
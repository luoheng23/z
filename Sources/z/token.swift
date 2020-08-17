// Copyright (c) 2019 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

public enum Token: String {
	eof = "eof"
	comment= "#"
	name = "name"        // user
	number = "number"      // 123
	str = "str"         // 'foo'
	str_inter   // 'name=$user.name'
	chartoken = "char"   // `A`
	plus = "+"
	minus = "-"
	mul = "*"
	div = "/"
	mod = "%"
	xor = "^" // ^
	pipe = "|" // |
	inc = "++" // ++
	dec = "--" // --
	and = "&&" // &&
	logical_or = "||"
	not = "!"
	bit_not = "~"
	question = "?"
	comma = ","
	semicolon = ";"
	colon = ":"
	amp = "&"
	dollar = "$"
	left_shift = "<<"
	righ_shift = ">>"
	at = "@"
	assign = "="
	plus_assign = "+=" // +=
	minus_assign = "-=" // -=
	div_assign = "/="
	mult_assign = "*="
	xor_assign = "^="
	mod_assign = "%="
	or_assign = "|="
	and_assign = "&="
	righ_shift_assign = ">>="
	left_shift_assign = "<<="
	// {}  () []
	lcbr = "{"
	rcbr = "}"
	lpar = "("
	rpar = ")"
	lsbr = "["
	rsbr = "]"
	// == != <= < >= >
	eq = "=="
	ne = "!="
	gt = ">"
	lt = "<"
	ge = ">="
	le = "<="
	// comments
	//line_com
	//mline_com
	nl = "\n"
	dot = "."
	dotdot = "..."
	// keywords
	key_is = "is"
	key_atomic = "atomic"
	key_break = "break"
	key_case = "case"
	key_const = "const"
	key_var = "var"
	key_continue = "continue"
	key_default = "default"
	key_defer = "defer"
	key_else = "else"
	key_enum = "enum"
	key_false = "false"
	key_for = "for"
	key_func = "func"
	key_go = "go"
	key_if = "if"
	key_import = "import"
	key_in = "in"
	key_interface = "interface"
	key_switch = "switch"
	key_mut = "mut"
	key_none = "nil"
	key_return = "return"
	key_struct = "struct"
	key_true = "true"
	key_type = "type"
	key_pub = "pub"
	key_static = "static"

	// buildKeys genereates a map with keywords' string values:
	// Keywords['return'] == .key_return
	func buildKeys() -> Map<String, String> {
		var res = [String: String]()
		for c in keywords {
			res[c] = c.rawValue
		}
		return res
	}

	static let keywords: [Token] = [
	.key_is,
	.key_atomic,
	.key_break,
	.key_case,
	.key_const,
	.key_var,
	.key_continue,
	.key_default,
	.key_defer,
	.key_else,
	.key_enum,
	.key_false,
	.key_for,
	.key_func,
	.key_go,
	.key_if,
	.key_import,
	.key_in,
	.key_interface,
	.key_switch,
	.key_mut,
	.key_none,
	.key_return,
	.key_struct,
	.key_true,
	.key_type,
	.key_pub,
	.key_static,
	]
	static let KEYWORDS = buildKeys()
	static let NrTokens = 140
	static let Decls: [Token] = [
		.key_enum,
		.key_interface,
		.key_func,
		.key_struct,
		.key_type,
		.key_const,
		.key_var,
		.key_mut,
		.key_pub,
	]

	static let Assigns = [
		Token.assign, Token.plus_assign, Token.minus_assign,
		Token.mult_assign, Token.div_assign, Token.xor_assign,
		Token.mod_assign,
		Token.or_assign, Token.and_assign, Token.righ_shift_assign,
		Token.left_shift_assign
	]

	static func keyToToken(key string) -> Token? {
		a := Token(rawValue: KEYWORDS[key] ?? "")
		return a
	}

	static func isKey(key string) -> bool {
		return keyToToken(key) != nil
	}

	func str() -> String {
		return self.rawValue
	}

	func isDecl() -> bool {
		return Decls.contains(self)
	}

	func isAssign() -> bool {
		return Assigns.contains(self)
	}
}
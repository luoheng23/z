class CodeGenerator {
    var tree: Ast

    init(_ tree: Ast) {
        self.tree = tree
    }

    func gen() -> String {
        return tree.gen()
    }
}

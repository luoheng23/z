
extension Parser {
    func varDecl() -> Stmt {
        check(.key_var)
        let left = expr()
        check(.assign)
        let right = expr()
        
    }

    
}
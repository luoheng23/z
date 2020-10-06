import XCTest

@testable import ZlangCore

final class StmtTests: BaseTests {
    func testCommentStmt() {
        let str = [
            """
            # hello world
            # hello world2
            """,
            """
            # This is a good comment
            # second comment
            """,
        ]
        multiExprTests(str, CommentStmt.self, "", .stmt)
    }

    func testDeferStmt() {
        let str = [
            "defer hello()",
            "defer hello.strange[hello]()",
            "defer good()",
        ]
        multiExprTests(str, DeferStmt.self, "", .stmt)
    }

    func testReturnStmt() {
        let str = [
            "return hello()",
            "return hello.strange[hello]()",
            "return good()",
        ]
        multiExprTests(str, ReturnStmt.self, "", .stmt)
    }

    func testGoStmt() {
        let str = [
            "go hello()",
            "go hello.strange[hello]()",
            "go good()",
        ]
        multiExprTests(str, GoStmt.self, "", .stmt)
    }

    func testImportStmt() {
        let str = [
            "import hello",
            "import hello",
            "import good",
        ]
        multiExprTests(str, ImportStmt.self, "", .stmt)
    }

    func testWithStmt() {
        let str = """
            with let s = open(file) {
                print(s)
            }
            """
        singleExprTest(str, WithStmt.self, "", .stmt)
    }

    func testForStmt() {
        let str = [
            """
            for {
                print("good")
            }
            """,
            """
            for word in good {
                print("whitespace")
            }
            """,
            """
            for 3 < 5 {
                print("hello world")
            }
            """,
        ]
        multiExprTests(str, ForStmt.self, "", .stmt)
    }

    func testIfStmt() {
        let str = [
            """
            if i in (1, 2, 3) {
                print("good")
            }
            """,
            """
            if word < good {
                print("whitespace")
            } else {
                print("hello")
            }
            """,
            """
            if 3 < 5 and 5 < 6 {
                print("hello world")
            } else if 3 < 4 and 5 < 6 {
                print("Hello world")
            } else {
                print("good")
            }
            """,
        ]
        multiExprTests(str, IfStmt.self, "", .stmt)
    }

    func testSwitchStmt() {
        let str = [
            """
            switch hello.good {
            default {
                print("good")
            }
            }
            """,
            """
            switch helloworld {
            case hello {}
            case good {}
            default {}
            }
            """,
        ]
        multiExprTests(str, SwitchStmt.self, "", .stmt)
    }

    func testAssignStmt() {
        let str = [
            """
            this.word[yes] = (hello, world)
            """,
            """
            this += hello
            """,
            """
            this **= hello
            """,
            """
            this **= hello
            """,
        ]
        multiExprTests(str, AssignStmt.self, "", .stmt)
    }

    static var allTests = [
        ("testCommentStmt", testCommentStmt),
        ("testGoStmt", testGoStmt),
        ("testReturnStmt", testReturnStmt),
        ("testDeferStmt", testDeferStmt),
        ("testWithStmt", testWithStmt),
        ("testImportStmt", testImportStmt),
        ("testAssignStmt", testAssignStmt),
        ("testSwitchStmt", testSwitchStmt),
        ("testIfStmt", testIfStmt),
        ("testForStmt", testForStmt),
    ]
}

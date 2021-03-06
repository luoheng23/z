// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "z",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(
            url: "https://github.com/deus-x-mackina/console-color",
            from: "0.1.1"
        ),
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.0"),
        .package(url: "https://github.com/luoheng23/ospath", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ZlangCore",
            dependencies: [
                "Files",
                "PathKit",
                "ospath",
                .product(name: "ConsoleColor", package: "console-color"),
            ]
        ),
        .testTarget(
            name: "ZlangCoreTests",
            dependencies: ["ZlangCore"]
        ),
        .target(
            name: "z",
            dependencies: ["ZlangCore"]
        ),
    ]
)

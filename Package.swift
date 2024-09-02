// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LegoBLE",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "LegoBLE", targets: ["LegoBLE"]),
        .executable(name: "AppLegoBLE", targets: ["AppLegoBLE"])
    ],
    dependencies: [.package(url: "https://github.com/psksvp/CommonSwift", branch: "master"),
                   .package(url: "https://github.com/psksvp/MinimalSwiftUI", branch: "main")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "LegoBLE", dependencies: [.product(name: "CommonSwift", package: "CommonSwift")]),
        .executableTarget(name: "AppLegoBLE", dependencies: [.product(name: "CommonSwift", package: "CommonSwift"),
                                                             .product(name: "MinimalSwiftUI", package: "MinimalSwiftUI"),
                                                             "LegoBLE"]),
        
        .testTarget(name: "LegoBLETests",
            dependencies: ["LegoBLE"]),
    ]
)

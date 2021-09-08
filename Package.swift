// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlowSwift",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FlowSwift",
            targets: ["FlowSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.17.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FlowSwift",
            dependencies: []),
        .testTarget(
            name: "FlowSwiftTests",
            dependencies: ["FlowSwift"]),
    ]
)

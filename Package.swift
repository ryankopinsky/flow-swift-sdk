// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlowSwift",
    platforms: [.macOS("10.15")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages. 
        .library(
            name: "FlowSwift",
            targets: ["Flow","FlowSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.17.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.3.0"),
        .package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.3.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.4.1")),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "7.0.0-rc1"),
        .package(
               name: "secp256k1",
               url: "https://github.com/GigaBitcoin/secp256k1.swift.git",
               from: "0.3.0"
           ),
      
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Flow",
            dependencies: ["SwiftProtobuf", .product(name: "GRPC", package: "grpc-swift")],
            resources: [
                .process("README.md"),
                .copy("Resources")]),
        
        .target(
            name: "FlowSwift",
            dependencies: ["Flow", "SwiftProtobuf", "SwiftPrettyPrint","BigInt","CryptoSwift","PromiseKit","secp256k1", .product(name: "GRPC", package: "grpc-swift"),
            
            ]),
        

        
        .testTarget(
            name: "FlowSwiftTests",
            dependencies: ["FlowSwift", "Flow", "SwiftProtobuf", .product(name: "GRPC", package: "grpc-swift")]),
    ]
    
    
)


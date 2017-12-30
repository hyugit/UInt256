// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UInt256",
    products: [
        .library(name: "UInt256", targets: ["UInt256"]),
    ],
    targets: [
        .target(name: "UInt256", path: "Sources"),
    ]
)

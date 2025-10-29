// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ZenUniffi",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ZenUniffi",
            targets: ["ZenUniffi"]  // ← Same name
        )
    ],
    targets: [
        .binaryTarget(
            name: "ZenUniffi",  // ← Same name as product
            path: "ZenUniffi.xcframework"
        )
    ]
)
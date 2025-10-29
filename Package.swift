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
            targets: ["ZenUniffi"]
        )
    ],
    targets: [
        // Explicit C module wrapper
        .systemLibrary(
            name: "zen_uniffiFFI",
            path: "Sources/zen_uniffiFFI"
        ),

        // Swift layer
        .target(
            name: "ZenUniffi",
            dependencies: ["zen_uniffiFFI", "ZenUniffiBinary"],
            path: "Sources/ZenUniffi"
        ),

        // Binary target with compiled Rust library
        .binaryTarget(
            name: "ZenUniffiBinary",
            path: "ZenUniffi.xcframework"
        )
    ]
)
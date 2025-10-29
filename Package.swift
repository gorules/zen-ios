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
        .target(
            name: "zen_uniffiFFI",
            path: "Sources/zen_uniffiFFI",
            publicHeadersPath: "."
        ),
        .target(
            name: "ZenUniffi",
            dependencies: ["zen_uniffiFFI", "ZenUniffiBinary"],
            path: "Sources/ZenUniffi"
        ),
        .binaryTarget(
            name: "ZenUniffiBinary",
            path: "ZenUniffi.xcframework"
        )
    ]
)
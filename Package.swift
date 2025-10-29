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
            name: "ZenUniffi",
            dependencies: ["ZenUniffiBinary"],
            path: "Sources/ZenUniffi",
            exclude: ["include/zen_uniffiFFI.modulemap"],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include")
            ]
        ),
        .binaryTarget(
            name: "ZenUniffiBinary",
            path: "ZenUniffi.xcframework"
        )
    ]
)

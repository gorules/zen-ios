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
            targets: ["ZenUniffiWrapper"]
        )
    ],
    targets: [
        .target(
            name: "ZenUniffiWrapper",
            dependencies: ["ZenUniffiBinary"],
            path: "Sources"
        ),
        .binaryTarget(
            name: "ZenUniffiBinary",
            path: "ZenUniffi.xcframework"
        )
    ]
)

// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "iTabPager",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "iTabPager", targets: ["iTabPager"]),
    ],
    targets: [
        .target(name: "iTabPager"),
        .testTarget(name: "iTabPagerTests", dependencies: ["iTabPager"]),
    ]
)

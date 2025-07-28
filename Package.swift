// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChineseAstrologyCalendar",
    platforms: [
      .iOS(.v13),
      .watchOS(.v5),
      .macOS(.v10_13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ChineseAstrologyCalendar",
            targets: ["ChineseAstrologyCalendar"]),
    ],
    dependencies: [
      .package(url: "https://github.com/airbnb/swift", from: "1.0.8"),
      .package(url: "https://github.com/apple/swift-numerics", from: "1.0.3"),
      .package(url: "git@github.com:xiangyu-sun/Astral.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ChineseAstrologyCalendar",
            dependencies: [
              .product(name: "Numerics", package: "swift-numerics"),
              .product(name: "Astral", package: "astral"),
            ]),
        .testTarget(
            name: "ChineseAstrologyCalendarTests",
            dependencies: ["ChineseAstrologyCalendar"]),
    ]
)

// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppImageViewer",
	platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "AppImageViewer", targets: ["AppImageViewer"]),
    ],
    targets: [
        .target(name: "AppImageViewer", dependencies: []),
        .testTarget(name: "AppImageViewerTests", dependencies: ["AppImageViewer"]),
    ],
	swiftLanguageVersions: [.v4_2]
)

// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "RaytracerChallenge",
    products: [
        .library(
            name: "RaytracerChallenge",
            targets: ["RaytracerChallenge"]),
        .executable(
            name: "Ticking",
            targets: ["Ticking"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RaytracerChallenge",
            dependencies: []),
        .target(
            name: "Ticking",
            dependencies: ["RaytracerChallenge"]),
        .testTarget(
            name: "RaytracerChallengeTests",
            dependencies: ["RaytracerChallenge"])
    ]
)

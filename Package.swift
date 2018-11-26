// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "RaytracerChallenge",
    products: [
        .library(name: "RaytracerChallenge",
                 targets: ["RaytracerChallenge"]),
        .executable(name: "Ticking",
                    targets: ["Ticking"]),
        .executable(name: "Projectile",
                    targets: ["Projectile"]),
        .executable(name: "Clock",
                    targets: ["Clock"])
    ],
    dependencies: [],
    targets: [
        .target(name: "RaytracerChallenge",
                dependencies: []),
        .target(name: "Ticking",
                dependencies: ["RaytracerChallenge"]),
        .target(name: "Projectile",
                dependencies: ["RaytracerChallenge"]),
        .target(name: "Clock",
                dependencies: ["RaytracerChallenge"]),
        .testTarget(name: "RaytracerChallengeTests",
                    dependencies: ["RaytracerChallenge"])
    ]
)

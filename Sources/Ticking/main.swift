import Foundation
import RaytracerChallenge

/// Excercise at the end of chapter 1
struct Projectile {
    let position: Tuple
    let velocity: Tuple

    init(position: Tuple, velocity: Tuple) {
        assert(position.isPoint)
        assert(velocity.isVector)
        self.position = position
        self.velocity = velocity
    }
}
struct Environment {
    let gravity: Tuple
    let wind: Tuple

    init(gravity: Tuple, wind: Tuple) {
        assert(gravity.isVector)
        assert(wind.isVector)
        self.gravity = gravity
        self.wind = wind
    }
}

func tick(env: Environment, proj: Projectile) -> Projectile {
    let position = proj.position + proj.velocity
    let velocity = proj.velocity + env.gravity + env.wind
    return Projectile(position: position, velocity: velocity)
}

var p = Projectile(position: .point(x: 0, y: 10, z: 0), velocity: Tuple.vector(x: 1, y: 1, z: 0).normalized)
let environment = Environment(gravity: .vector(x: 0, y: -0.1, z: 0), wind: .vector(x: -0.1, y: 0, z: 0))

while p.position.y > 0 {
    print("\(p.position)")
    p = tick(env: environment, proj: p)
}

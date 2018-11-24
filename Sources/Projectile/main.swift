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

var projectile = Projectile(position: .point(x: 0, y: 1, z: 0),
                            velocity: Tuple.vector(x: 1, y: 1.8, z: 0).normalized * 11.25)

let environment = Environment(gravity: .vector(x: 0, y: -0.1, z: 0),
                              wind: .vector(x: -0.01, y: 0, z: 0))
let red = Color(red: 1, green: 0, blue: 0)

func tick(environment: Environment, projectile: Projectile) -> Projectile {
    let position = projectile.position + projectile.velocity
    let velocity = projectile.velocity + environment.gravity + environment.wind
    return Projectile(position: position, velocity: velocity)
}

var canvas = Canvas(width: 900, height: 550)

while projectile.position.y > 0 {
    let (x, y) = (Int(projectile.position.x), canvas.height - Int(projectile.position.y))
    if canvas.validate(x: x, y: y) {
        canvas[x: x, y: y] = red
    }
    projectile = tick(environment: environment, projectile: projectile)
}

let ppm = PPMGenerator(canvas: canvas)

// get URL to the the documents directory in the sandbox
guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Failed to get documents directory")
}
// add a filename
let fileUrl = documentsUrl.appendingPathComponent("projectile.ppm")

// write to it
try ppm.contents.write(to: fileUrl, atomically: true, encoding: .utf8)

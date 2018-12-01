import Foundation
import RaytracerChallenge

/// Excercise at the end of chapter 7
let floor = Sphere(transform: .scaling(x: 10, y: 0.01, z: 10),
                   material: Material(color: Color(red: 1, green: 0.9, blue: 0.9), specular: 0))

let leftWall = Sphere(transform: Matrix.scaling(x: 10, y: 0.1, z: 10).rotated(x: .pi / 2)
                                 .rotated(y: -.pi / 4).translated(x: 0, y: 0, z: 5),
                      material: floor.material)

let rightWall = Sphere(transform: Matrix.scaling(x: 10, y: 0.1, z: 10).rotated(x: .pi / 2)
                                  .rotated(y: .pi / 4).translated(x: 0, y: 0, z: 5),
                       material: floor.material)

let middle = Sphere(transform: .translation(x: 0.5, y: 1, z: 0.5),
                    material: Material(color: Color(red: 0.1, green: 1, blue: 0.5),
                                       diffuse: 0.7,
                                       specular: 0.3))

let right = Sphere(transform: Matrix.scaling(x: 0.5, y: 0.5, z: 0.5).translated(x: 1.5, y: 0.5, z: -0.75),
                   material: Material(color: Color(red: 0.5, green: 1, blue: 0.1),
                                      diffuse: 0.7,
                                      specular: 0.3))

let left = Sphere(transform: Matrix.scaling(x: 0.3, y: 0.3, z: 0.3).translated(x: -1.5, y: 0.3, z: -0.75),
                  material: Material(color: Color(red: 1, green: 0.8, blue: 0.1),
                                     diffuse: 0.7,
                                     specular: 0.3))

let light = PointLight(position: .point(x: -10, y: 10, z: -10), intensity: .white)

let world = World(objects: [floor, leftWall, rightWall, middle, right, left], lights: [light])

let camera: Camera = {
    var camera = Camera(hSize: 512, vSize: 256, fieldOfView: .pi / 3)
    camera.transform = Matrix(from: .point(x: 0, y: 1.5, z: -5),
                              to: .point(x: 0, y: 1, z: 0),
                              up: .vector(x: 0, y: 1, z: 0))
    return camera
}()

let canvas = camera.render(world)

let ppm = PPMGenerator(canvas: canvas)

// get URL to the the documents directory in the sandbox
guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Failed to get documents directory")
}
// add a filename
let fileUrl = documentsUrl.appendingPathComponent("world.ppm")

// write to it
try ppm.contents.write(to: fileUrl, atomically: true, encoding: .utf8)

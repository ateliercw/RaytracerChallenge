import Foundation
import RaytracerChallenge

/// Excercise at the end of chapter 6
let sphere = Sphere(material: .init(color: Color(red: 1, green: 0.2, blue: 1)))

let light = PointLight(position: .point(x: -10, y: 10, z: -10))
let canvasPixels = 256
var canvas = Canvas(width: canvasPixels, height: canvasPixels)
let red = Color(red: 1, green: 0, blue: 0)

let rayOrigin = Tuple.point(x: 0, y: 0, z: -5)
let wallZ: Float = 10
let wallSize: Float = 7
let pixelSize = wallSize / Float(canvasPixels)
let halfWallSize = wallSize / 2

for y in 0..<canvasPixels {
    let worldY = halfWallSize - pixelSize * Float(y)
    for x in 0..<canvasPixels {
        let worldX = -halfWallSize + pixelSize * Float(x)
        let position = Tuple.point(x: worldX, y: worldY, z: wallZ)
        let ray = Ray(origin: rayOrigin,
                      direction: (position - rayOrigin).normalized)
        guard let hit = sphere.intersections(ray).hit else { continue }
        let point = ray.position(hit.distance)
        let normal = hit.object.normal(at: point)
        let eye = -ray.direction
        canvas[x: x, y: y] = hit.object.material.lighting(light: light, position: point, eyeVector: eye, normalVector: normal)
    }
}

let ppm = PPMGenerator(canvas: canvas)

// get URL to the the documents directory in the sandbox
guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Failed to get documents directory")
}
// add a filename
let fileUrl = documentsUrl.appendingPathComponent("shadedSphere.ppm")

// write to it
try ppm.contents.write(to: fileUrl, atomically: true, encoding: .utf8)

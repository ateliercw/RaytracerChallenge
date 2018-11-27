import Foundation
import RaytracerChallenge

/// Excercise at the end of chapter 5
let sphere = Sphere()
let canvasPixels = 128
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
        if sphere.intersections(ray).hit != nil {
            canvas[x: x, y: y] = red
        }
    }
}

let ppm = PPMGenerator(canvas: canvas)

// get URL to the the documents directory in the sandbox
guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Failed to get documents directory")
}
// add a filename
let fileUrl = documentsUrl.appendingPathComponent("sphere.ppm")

// write to it
try ppm.contents.write(to: fileUrl, atomically: true, encoding: .utf8)

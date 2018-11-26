import Foundation
import RaytracerChallenge

private extension Color {
    static let white = Color(red: 1, green: 1, blue: 1)
}

extension Canvas {
    mutating func draw(x: Int, y: Int) {
        for xMark in (x - 1)..<(x + 1) {
            for yMark in (y - 1)..<(y + 1) {
                self[x: xMark, y: yMark] = .white
            }
        }
    }
}

var canvas = Canvas(width: 300, height: 300)

let origin = Tuple.point(x: 0, y: 0, z: 0)

let white = Color(red: 1, green: 1, blue: 1)

for position in (0..<12).map(Float.init) {
    let p = Matrix.translation(x: 120, y: 0, z: 0).rotated(z: position * .pi / 6) * origin
    canvas.draw(x: Int(p.x) + 150, y: Int(p.y) + 150)
}

let ppm = PPMGenerator(canvas: canvas)

// get URL to the the documents directory in the sandbox
guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Failed to get documents directory")
}
// add a filename
let fileUrl = documentsUrl.appendingPathComponent("clock.ppm")

// write to it
try ppm.contents.write(to: fileUrl, atomically: true, encoding: .utf8)

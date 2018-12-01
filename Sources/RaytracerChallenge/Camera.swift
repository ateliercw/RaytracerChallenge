import Foundation

public struct Camera: Equatable, Hashable {
    public var hSize: Int
    public var vSize: Int
    public var fieldOfView: Float {
        didSet { halfView = tan(fieldOfView / 2) }
    }
    public var transform: Matrix

    public init(hSize: Int, vSize: Int, fieldOfView: Float) {
        self.hSize = hSize
        self.vSize = vSize
        self.fieldOfView = fieldOfView
        halfView = tan(fieldOfView / 2)
        transform = .identity
    }

    private var halfView: Float
    private var aspectRatio: Float { return Float(hSize) / Float(vSize) }
    private var halfWidth: Float { return aspectRatio >= 1 ? halfView : halfView * aspectRatio }
    private var halfHeight: Float { return aspectRatio >= 1 ? halfView / aspectRatio : halfView }
    public var pixelSize: Float { return (halfWidth * 2) / Float(hSize) }

    func rayForPixel(x: Int, y: Int) -> Ray {
        let pixelSize = self.pixelSize
        // the offset from the edge of the canvas to the pixel's center
        let xOffset = (Float(x) + 0.5) * pixelSize
        let yOffset = (Float(y) + 0.5) * pixelSize

        // the untransformed coordinates of the pixel in world-space.
        // (remember that the camera looks toward -z, so +x is to the left)
        let worldX = halfWidth - xOffset
        let worldY = halfHeight - yOffset

        // using the camera matrix, tranform the canvas point and the origin,
        // and compute the ray's direction vextor.
        // (remember the camrea is at z =- 1)
        guard let inverse = transform.inverse else {
            assertionFailure("Failed to invert tranform")
            return Ray(origin: .point(x: 0, y: 0, z: 0), direction: .vector(x: 0, y: 0, z: 0))
        }
        let pixel = inverse * .point(x: worldX, y: worldY, z: -1)
        let origin = inverse * .point(x: 0, y: 0, z: 0)
        let direction = (pixel - origin).normalized

        return Ray(origin: origin, direction: direction)
    }

    public func render(_ world: World) -> Canvas {
        var canvas = Canvas(width: hSize, height: vSize)
        for x in 0..<hSize {
            for y in 0..<vSize {
                canvas[x: x, y: y] = world.color(at: rayForPixel(x: x, y: y))
            }
        }
        return canvas
    }
}

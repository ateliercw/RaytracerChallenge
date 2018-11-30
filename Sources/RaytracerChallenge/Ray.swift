import Foundation

public struct Ray: Equatable, Hashable {
    public var origin: Tuple
    public var direction: Tuple

    public init(origin: Tuple, direction: Tuple) {
        assert(origin.isPoint, "origin must be a point")
        assert(direction.isVector, "direction must be a vector")
        self.origin = origin
        self.direction = direction
    }

    public func position(_ distance: Float) -> Tuple {
        return origin + (direction * distance)
    }

    public static func * (ray: Ray, transform: Matrix) -> Ray {
        return Ray(origin: transform * ray.origin,
                   direction: transform * ray.direction)
    }
}

import Foundation

public struct Sphere: Equatable, Hashable, GeometryObject {
    public let id: UUID
    public var transform: Matrix
    public var material: Material

    public init(transform: Matrix = .identity, material: Material = Material()) {
        id = UUID()
        self.transform = transform
        self.material = material
    }

    public func intersections(_ ray: Ray) -> [Intersection] {
        guard let ray = transform.inverse.map({ ray * $0 }) else {
            assertionFailure("Failed to invert transform")
            return []
        }
        let distance = ray.origin - .origin

        let a = ray.direction.dot(ray.direction)
        let b = 2 * ray.direction.dot(distance)
        let c = distance.dot(distance) - 1

        let discriminant = pow(b, 2) - 4 * a * c
        guard discriminant >= 0 else { return [] }

        let sqrtDiscriminant = sqrt(discriminant)
        let t1 = (-b - sqrtDiscriminant) / (2 * a)
        let t2 = (-b + sqrtDiscriminant) / (2 * a)

        return  [t1, t2].map { Intersection(distance: $0, object: self) }
    }

    public func normal(at point: Tuple) -> Tuple {
        guard let inverse = transform.inverse else {
            fatalError("Failed to invert transform")
        }
        let objectPoint = inverse * point
        let objectNormal = objectPoint - .origin
        var worldNormal = inverse.transposed * objectNormal
        worldNormal.w = 0
        return worldNormal.normalized
    }
}

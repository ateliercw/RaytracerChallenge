import Foundation

public struct Sphere: Equatable, Hashable {
    public let id: UUID
    public var transform: Matrix

    public init(transform: Matrix = .identity) {
        id = UUID()
        self.transform = transform
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

        return  [t1, t2].map { Intersection(distance: $0, object: .sphere(self)) }
    }
}

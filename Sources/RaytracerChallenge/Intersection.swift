import Foundation

public struct Intersection: Equatable, Hashable, Comparable {
    public enum Object: Equatable, Hashable {
        case sphere(Sphere)

        public var sphere: Sphere? {
            if case .sphere(let sphere) = self { return sphere }
            return nil
        }
    }

    public let distance: Float
    public let object: Intersection.Object

    public init(distance: Float, object: Intersection.Object) {
        self.distance = distance
        self.object = object
    }

    public var isIntersection: Bool { return self.distance >= 0 }
    public static func < (lhs: Intersection, rhs: Intersection) -> Bool {
        return lhs.distance < rhs.distance
    }
}

public extension Array where Element == Intersection {
    public var hit: Intersection? {
        return self.filter({ $0.distance >= 0 }).sorted().first
    }
}

import Foundation

public struct Intersection: Equatable, Hashable, Comparable {
    public let distance: Float
    public let object: GeometryObject

    public init(distance: Float, object: GeometryObject) {
        self.distance = distance
        self.object = object
    }

    public var isIntersection: Bool { return self.distance >= 0 }
    public static func < (lhs: Intersection, rhs: Intersection) -> Bool {
        return lhs.distance < rhs.distance
    }

    public static func == (lhs: Intersection, rhs: Intersection) -> Bool {
        return lhs.object.id == rhs.object.id && lhs.distance.isEqualTo(rhs.distance, epsilon: .epsilon)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(distance)
        hasher.combine(object.id)
    }
}

public extension Array where Element == Intersection {
    public var hit: Intersection? {
        return self.filter({ $0.distance >= 0 }).sorted().first
    }
}

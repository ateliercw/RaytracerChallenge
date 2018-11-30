import Foundation

struct IntersectionState: Equatable, Hashable {
    let intersection: Intersection
    let ray: Ray
    let point: Tuple
    let eyeV: Tuple
    let normalV: Tuple
    let isInside: Bool

    init(intersection: Intersection, ray: Ray) {
        self.intersection = intersection
        self.ray = ray
        self.point = ray.position(intersection.distance)
        self.eyeV = -ray.direction
        let normalV = intersection.object.normal(at: self.point)
        self.isInside = normalV.dot(self.eyeV) < 0
        self.normalV = self.isInside ? -normalV : normalV
    }

    var object: GeometryObject { return intersection.object }
    var distace: Float { return intersection.distance }
}

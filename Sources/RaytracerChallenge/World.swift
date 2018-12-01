import Foundation

public struct World {
    public var objects: [GeometryObject]
    public var lights: [PointLight]

    public init(objects: [GeometryObject] = [], lights: [PointLight] = []) {
        self.objects = objects
        self.lights = lights
    }

    func intersect(with ray: Ray) -> [Intersection] {
        return self.objects.flatMap({ return $0.intersections(ray) }).sorted()
    }

    func shadeHit(with intersectionState: IntersectionState) -> Color {
        return lights.reduce(into: Color.black) { result, light in
            result = result +
                intersectionState.object.material.lighting(light: light,
                                                           position: intersectionState.point,
                                                           eyeVector: intersectionState.eyeV,
                                                           normalVector: intersectionState.normalV,
                                                           isInShadow: isShadowed(point: intersectionState.point,
                                                                                  light: light))
        }
    }

    public func color(at ray: Ray) -> Color {
        guard let hit = intersect(with: ray).hit else { return .black }
        return shadeHit(with: IntersectionState(intersection: hit, ray: ray))
    }

    func isShadowed(point: Tuple, light: PointLight) -> Bool {
        let v = light.position - point
        let distance = v.magnitude
        let direction = v.normalized
        let ray = Ray(origin: point, direction: direction)
        let intersections = intersect(with: ray)

        guard let hit = intersections.hit else { return false }
        return hit.distance < distance
    }
}

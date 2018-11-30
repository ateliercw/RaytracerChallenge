import Foundation

public protocol GeometryObject {
    var id: UUID { get }
    var transform: Matrix { get }
    var material: Material { get }

    func intersections(_ ray: Ray) -> [Intersection]
    func normal(at point: Tuple) -> Tuple
}

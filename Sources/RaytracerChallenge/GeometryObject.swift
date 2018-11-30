import Foundation

public protocol GeometryObject {
    var id: UUID { get }
    var transform: Matrix { get set }
    var material: Material { get set }

    func intersections(_ ray: Ray) -> [Intersection]
    func normal(at point: Tuple) -> Tuple
}

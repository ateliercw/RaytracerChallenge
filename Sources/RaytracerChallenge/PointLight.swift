import Foundation

public struct PointLight: Equatable, Hashable {
    public var intensity: Color
    public var position: Tuple {
        didSet {
            assert(position.isPoint, "position must be a point")
        }
    }

    public init(position: Tuple, intensity: Color = .white) {
        assert(position.isPoint, "Light must be constructed with a point")
        self.intensity = intensity
        self.position = position
    }
}

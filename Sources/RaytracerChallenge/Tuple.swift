import Foundation

public struct Tuple: Equatable {
    public static let zeroVector = Tuple.vector(x: 0, y: 0, z: 0)

    public var x: Float
    public var y: Float
    public var z: Float
    public var w: Float

    public static func point(x: Float, y: Float, z: Float) -> Tuple {
        return .init(x: x, y: y, z: z, w: 1)
    }

    public static func vector(x: Float, y: Float, z: Float) -> Tuple {
        return .init(x: x, y: y, z: z, w: 0)
    }

    public var isPoint: Bool { return self.w.isEqualTo(1, epsilon: .epsilon) }
    public var isVector: Bool { return self.w.isEqualTo(0, epsilon: .epsilon) }

    public static func == (lhs: Tuple, rhs: Tuple) -> Bool {
        return lhs.x.isEqualTo(rhs.x, epsilon: .epsilon) &&
            lhs.y.isEqualTo(rhs.y, epsilon: .epsilon) &&
            lhs.z.isEqualTo(rhs.z, epsilon: .epsilon) &&
            lhs.w.isEqualTo(rhs.w, epsilon: .epsilon)
    }

    public static func + (lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(x: lhs.x + rhs.x,
                     y: lhs.y + rhs.y,
                     z: lhs.z + rhs.z,
                     w: lhs.w + rhs.w)
    }

    public static func - (lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(x: lhs.x - rhs.x,
                     y: lhs.y - rhs.y,
                     z: lhs.z - rhs.z,
                     w: lhs.w - rhs.w)
    }

    public static func * (lhs: Tuple, rhs: Float) -> Tuple {
        return Tuple(x: lhs.x * rhs,
                     y: lhs.y * rhs,
                     z: lhs.z * rhs,
                     w: lhs.w * rhs)
    }

    public static func / (lhs: Tuple, rhs: Float) -> Tuple {
        return Tuple(x: lhs.x / rhs,
                     y: lhs.y / rhs,
                     z: lhs.z / rhs,
                     w: lhs.w / rhs)
    }

    public static prefix func - (rhs: Tuple) -> Tuple {
        return Tuple(x: -rhs.x,
                     y: -rhs.y,
                     z: -rhs.z,
                     w: -rhs.w)
    }

    public func dot(_ rhs: Tuple) -> Float {
        assert(self.isVector)
        assert(rhs.isVector)
        let dotX = x * rhs.x
        let dotY = y * rhs.y
        let dotZ = z * rhs.z
        let dotW = w * rhs.w
        return dotX + dotY + dotZ + dotW
    }

    public func cross(_ rhs: Tuple) -> Tuple {
        assert(self.isVector)
        assert(rhs.isVector)
        return .vector(x: y * rhs.z - z * rhs.y,
                       y: z * rhs.x - x * rhs.z,
                       z: x * rhs.y - y * rhs.x)
    }

    public var magnitude: Float {
        let xSquared = pow(x, 2)
        let ySquared = pow(y, 2)
        let zSquared = pow(z, 2)
        let wSquared = pow(w, 2)
        let total = xSquared + ySquared + zSquared + wSquared
        return sqrt(total)
    }

    public var normalized: Tuple {
        let magnitude = self.magnitude
        return Tuple(x: x / magnitude,
                     y: y / magnitude,
                     z: z / magnitude,
                     w: w / magnitude)
    }
}

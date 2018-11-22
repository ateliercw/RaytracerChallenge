import Foundation

struct Tuple: Equatable {
    static let zeroVector = Tuple.vector(x: 0, y: 0, z: 0)

    var x: Float
    var y: Float
    var z: Float
    var w: Float

    static func point(x: Float, y: Float, z: Float) -> Tuple {
        return .init(x: x, y: y, z: z, w: 1)
    }

    static func vector(x: Float, y: Float, z: Float) -> Tuple {
        return .init(x: x, y: y, z: z, w: 0)
    }

    var isPoint: Bool { return self.w.isEqualTo(1, epsilon: .epsilon) }
    var isVector: Bool { return self.w.isEqualTo(0, epsilon: .epsilon) }

    static func == (lhs: Tuple, rhs: Tuple) -> Bool {
        return lhs.x.isEqualTo(rhs.x, epsilon: .epsilon) &&
            lhs.y.isEqualTo(rhs.y, epsilon: .epsilon) &&
            lhs.z.isEqualTo(rhs.z, epsilon: .epsilon) &&
            lhs.w.isEqualTo(rhs.w, epsilon: .epsilon)
    }

    static func + (lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(x: lhs.x + rhs.x,
                     y: lhs.y + rhs.y,
                     z: lhs.z + rhs.z,
                     w: lhs.w + rhs.w)
    }

    static func - (lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(x: lhs.x - rhs.x,
                     y: lhs.y - rhs.y,
                     z: lhs.z - rhs.z,
                     w: lhs.w - rhs.w)
    }

    static func * (lhs: Tuple, rhs: Float) -> Tuple {
        return Tuple(x: lhs.x * rhs,
                     y: lhs.y * rhs,
                     z: lhs.z * rhs,
                     w: lhs.w * rhs)
    }

    static func / (lhs: Tuple, rhs: Float) -> Tuple {
        return Tuple(x: lhs.x / rhs,
                     y: lhs.y / rhs,
                     z: lhs.z / rhs,
                     w: lhs.w / rhs)
    }

    static prefix func - (rhs: Tuple) -> Tuple {
        return Tuple(x: -rhs.x,
                     y: -rhs.y,
                     z: -rhs.z,
                     w: -rhs.w)
    }

    func dot(_ rhs: Tuple) -> Float {
        assert(self.isVector)
        assert(rhs.isVector)
        let dotX = x * rhs.x
        let dotY = y * rhs.y
        let dotZ = z * rhs.z
        let dotW = w * rhs.w
        return dotX + dotY + dotZ + dotW
    }

    func cross(_ rhs: Tuple) -> Tuple {
        assert(self.isVector)
        assert(rhs.isVector)
        return .vector(x: y * rhs.z - z * rhs.y,
                       y: z * rhs.x - x * rhs.z,
                       z: x * rhs.y - y * rhs.x)
    }

    var magnitude: Float {
        let xSquared = pow(x, 2)
        let ySquared = pow(y, 2)
        let zSquared = pow(z, 2)
        let wSquared = pow(w, 2)
        let total = xSquared + ySquared + zSquared + wSquared
        return sqrt(total)
    }

    var normalized: Tuple {
        let magnitude = self.magnitude
        return Tuple(x: x / magnitude,
                     y: y / magnitude,
                     z: z / magnitude,
                     w: w / magnitude)
    }
}

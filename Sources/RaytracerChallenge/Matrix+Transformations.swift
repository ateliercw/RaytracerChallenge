import Foundation

extension Matrix {
    public func translated(x: Float, y: Float, z: Float) -> Matrix {
        return Matrix.translation(x: x, y: y, z: z) * self
    }

    public func scaled(x: Float, y: Float, z: Float) -> Matrix {
        return Matrix.scaling(x: x, y: y, z: z) * self
    }

    public func rotated(x: Float) -> Matrix {
        return Matrix.rotation(x: x) * self
    }

    public func rotated(y: Float) -> Matrix {
        return Matrix.rotation(y: y) * self
    }

    public func rotated(z: Float) -> Matrix {
        return Matrix.rotation(z: z) * self
    }

    public func sheared(xY: Float = 0,
                        xZ: Float = 0,
                        yX: Float = 0,
                        yZ: Float = 0,
                        zX: Float = 0,
                        zY: Float = 0) -> Matrix {
        return Matrix.shearing(xY: xY, xZ: xZ, yX: yX, yZ: yZ, zX: zX, zY: zY) * self
    }

    public static func translation(x: Float, y: Float, z: Float) -> Matrix {
        var translation = Matrix.identity
        translation[row: 0, column: 3] = x
        translation[row: 1, column: 3] = y
        translation[row: 2, column: 3] = z
        return translation
    }

    public static func scaling(x: Float, y: Float, z: Float) -> Matrix {
        var scaled = Matrix.identity
        scaled[row: 0, column: 0] = x
        scaled[row: 1, column: 1] = y
        scaled[row: 2, column: 2] = z
        return scaled
    }

    public static func rotation(x: Float) -> Matrix {
        var scaled = Matrix.identity
        let cosX = cos(x)
        let sinX = sin(x)
        scaled[row: 1, column: 1] = cosX
        scaled[row: 1, column: 2] = -sinX
        scaled[row: 2, column: 1] = sinX
        scaled[row: 2, column: 2] = cosX
        return scaled
    }

    public static func rotation(y: Float) -> Matrix {
        var scaled = Matrix.identity
        let cosY = cos(y)
        let sinY = sin(y)
        scaled[row: 0, column: 0] = cosY
        scaled[row: 0, column: 2] = sinY
        scaled[row: 2, column: 0] = -sinY
        scaled[row: 2, column: 2] = cosY
        return scaled
    }

    public static func rotation(z: Float) -> Matrix {
        var scaled = Matrix.identity
        let cosZ = cos(z)
        let sinZ = sin(z)
        scaled[row: 0, column: 0] = cosZ
        scaled[row: 0, column: 1] = -sinZ
        scaled[row: 1, column: 0] = sinZ
        scaled[row: 1, column: 1] = cosZ
        return scaled
    }

    public static func shearing(xY: Float = 0,
                                xZ: Float = 0,
                                yX: Float = 0,
                                yZ: Float = 0,
                                zX: Float = 0,
                                zY: Float = 0) -> Matrix {
        var sheared = Matrix.identity
        sheared[row: 0, column: 1] = xY
        sheared[row: 0, column: 2] = xZ
        sheared[row: 1, column: 0] = yX
        sheared[row: 1, column: 2] = yZ
        sheared[row: 2, column: 0] = zX
        sheared[row: 2, column: 1] = zY
        return sheared
    }
}

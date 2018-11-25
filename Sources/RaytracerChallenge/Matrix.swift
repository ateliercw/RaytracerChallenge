import Foundation

public struct Matrix: Equatable {
    private var matrix: [[Float]]

    public init(rows: Int, columns: Int, repeating: Float = 0) {
        let row = [Float](repeating: repeating, count: columns)
        matrix = [[Float]].init(repeating: row, count: rows)
    }

    public static let identity = Matrix([[1, 0, 0, 0],
                                         [0, 1, 0, 0],
                                         [0, 0, 1, 0],
                                         [0, 0, 0, 1]])

    public init (_ rawMatrix: [[Float]]) {
        matrix = rawMatrix
    }

    public subscript(row row: Int, column column: Int) -> Float {
        get {
            return matrix[row][column]
        }
        set {
            matrix[row][column] = newValue
        }
    }

    public var width: Int {
        return matrix.first?.count ?? 0
    }

    public var height: Int {
        return matrix.count
    }

    static public func * (lhs: Matrix, rhs: Matrix) -> Matrix {
        assert(lhs.width == rhs.width, "Matrices should be the same width")
        assert(lhs.height == rhs.height, "Matrices should be the same height")

        let size = 0..<lhs.height

        return allCombinations(size, size)
            .reduce(into: Matrix(rows: lhs.width, columns: lhs.height)) { result, position in
            let (y, x) = position
            let row = lhs.matrix[y][size]
            let column = rhs.matrix.map({ $0[x] })
            result[row: y, column: x] = zip(row, column).reduce(into: 0) { result, args in
                result += args.0 * args.1
            }
        }
    }

    static public func * (lhs: Matrix, rhs: Tuple) -> Tuple {
        assert(lhs.height == 4, "Only 4xN matrices can be multiplied by tuples")
        let rhsFloats = rhs.rawFloats
        let floats = lhs.matrix.map { row in
            return row.enumerated().reduce(into: 0 as Float) { result, step in
                result += step.element * rhsFloats[step.offset]
            }
        }
        return Tuple(floats: floats)
    }

    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        guard lhs.matrix.count == rhs.matrix.count else { return false }
        return zip(lhs.matrix, rhs.matrix).allSatisfy { (lhsRow, rhsRow) in
            guard lhsRow.count == rhsRow.count else { return false }
            return zip(lhsRow, rhsRow).allSatisfy { set in
                let (lhsNumber, rhsNumber) = set
                return lhsNumber.isEqualTo(rhsNumber, epsilon: .epsilon)
            }
        }
    }

    public var transposed: Matrix {
        return matrix.enumerated().reduce(into: Matrix(rows: width, columns: height, repeating: 0)) { result, row in
            for (column, value) in row.element.enumerated() {
                result[row: column, column: row.offset] = value
            }
        }
    }

    public var determinant: Float {
        assert(width == height, "Determinants need a balanced width / height")
        assert(width != 1, "Can't calculate determinant on a 1x1 matrix")
        guard width != 2 else {
            return self[row: 0, column: 0] * self[row: 1, column: 1] -
                self[row: 0, column: 1] * self[row: 1, column: 0]
        }
        return matrix[0].enumerated().reduce(into: 0) { result, step in
            result += step.element * cofactor(row: 0, column: step.offset)
        }
    }

    public func submatrix(row rowToRemove: Int, column columnToRemove: Int) -> Matrix {
        assert(rowToRemove < height && columnToRemove < width, "Removed values must be inside the matrix")
        let submatrix = matrix.enumerated().compactMap { item -> [Float]? in
            guard item.offset != rowToRemove else { return nil }
            var row = item.element
            row.remove(at: columnToRemove)
            return row
        }
        return Matrix(submatrix)
    }

    public func minor(row: Int, column: Int) -> Float {
        return submatrix(row: row, column: column).determinant
    }

    public func cofactor(row: Int, column: Int) -> Float {
        if (row + column) % 2 == 0 {
            return minor(row: row, column: column)
        } else {
            return -minor(row: row, column: column)
        }
    }

    private var inverible: Bool {
        return self.determinant != 0
    }

    public var inverse: Matrix? {
        assert(width == height, "Width must equal height to invert")
        guard self.inverible else { return nil }
        let cachedDeterminant = determinant
        var newMatrix = Matrix(rows: width, columns: height)
        for (row, column) in allCombinations(0..<width, 0..<height) {
            newMatrix[row: column, column: row] = cofactor(row: row, column: column) / cachedDeterminant
        }
        return newMatrix
    }
}

private func allCombinations<Collection1, Collection2>(_ lhs: Collection1, _ rhs: Collection2)
    -> [(Collection1.Element, Collection2.Element)] where Collection1: Collection, Collection2: Collection {
        return lhs.flatMap { leftItem in
            return rhs.map { (leftItem, $0) }
        }
}

private extension Tuple {
    init(floats: [Float]) {
        assert(floats.count == 4, "Tuple needs 4 floats to be initialized")
        self = .init(x: floats[0], y: floats[1], z: floats[2], w: floats[03])
    }

    var rawFloats: [Float] {
        return [x, y, z, w]
    }
}

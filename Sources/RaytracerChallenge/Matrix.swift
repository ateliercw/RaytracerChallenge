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

    public subscript(row row: Int, col col: Int) -> Float {
        get {
            return matrix[row][col]
        }
        set {
            matrix[row][col] = newValue
        }
    }

    var width: Int {
        return matrix.first?.count ?? 0
    }

    var height: Int {
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
            let col = rhs.matrix.map({ $0[x] })
            result[row: y, col: x] = zip(row, col).reduce(into: 0) { result, args in
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
            return zip(lhsRow, rhsRow).allSatisfy { (lhsNumber, rhsNumber) in
                return lhsNumber.isEqualTo(rhsNumber, epsilon: .epsilon)
            }
        }
    }

    var transposed: Matrix {
        return matrix.enumerated().reduce(into: Matrix(rows: width, columns: height, repeating: 0)) { result, row in
            for (col, value) in row.element.enumerated() {
                result[row: col, col: row.offset] = value
            }
        }
    }
}

private func allCombinations<Collection1, Collection2>(_ lhs: Collection1, _ rhs: Collection2)
    -> [(Collection1.Element, Collection2.Element)] where Collection1: Collection, Collection2: Collection {
        return lhs.flatMap { (leftItem) -> [(Collection1.Element, Collection2.Element)] in
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

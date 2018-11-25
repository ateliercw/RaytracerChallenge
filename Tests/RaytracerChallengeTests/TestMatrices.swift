import XCTest
@testable import RaytracerChallenge

class TestMatrices: XCTestCase {
    /// Constructing and inspecting a 4x4 matrix
    func testMatrix() {
        let m = Matrix([[1, 2, 3, 4],
                        [5.5, 6.5, 7.5, 8.5],
                        [9, 10, 11, 12],
                        [13.5, 14.5, 15.5, 16.5]])
        XCTAssertEqual(m[row: 0, column: 0], 1, accuracy: .epsilon)
        XCTAssertEqual(m[row: 0, column: 3], 4, accuracy: .epsilon)
        XCTAssertEqual(m[row: 1, column: 0], 5.5, accuracy: .epsilon)
        XCTAssertEqual(m[row: 1, column: 2], 7.5, accuracy: .epsilon)
        XCTAssertEqual(m[row: 2, column: 2], 11, accuracy: .epsilon)
        XCTAssertEqual(m[row: 3, column: 0], 13.5, accuracy: .epsilon)
        XCTAssertEqual(m[row: 3, column: 2], 15.5, accuracy: .epsilon)
    }

    // A 2x2 matrix ought to be representable
    func testTwoByTwoMatrix() {
        let m = Matrix([[-3, 5],
                        [1, -2]])
        XCTAssertEqual(m[row: 0, column: 0], -3, accuracy: .epsilon)
        XCTAssertEqual(m[row: 0, column: 1], 5, accuracy: .epsilon)
        XCTAssertEqual(m[row: 1, column: 0], 1, accuracy: .epsilon)
        XCTAssertEqual(m[row: 1, column: 1], -2, accuracy: .epsilon)
    }

    /// A 3x3 matrix ought to be representable
    func testThreeByThreeMatrix() {
        let m = Matrix([[-3, 5, 0],
                        [1, -2, -7],
                        [0, 1, 1]])
        XCTAssertEqual(m[row: 0, column: 0], -3, accuracy: .epsilon)
        XCTAssertEqual(m[row: 1, column: 1], -2, accuracy: .epsilon)
        XCTAssertEqual(m[row: 2, column: 2], 1, accuracy: .epsilon)
    }

    /// Matrix equality with identical matrices
    func testMatrixEquality() {
        let a = Matrix([[1, 2, 3, 4],
                        [5, 6, 7, 8],
                        [9, 8, 7, 6],
                        [5, 4, 3, 2]])
        let b = Matrix([[1, 2, 3, 4],
                        [5, 6, 7, 8],
                        [9, 8, 7, 6],
                        [5, 4, 3, 2]])
        XCTAssertEqual(a, b)
    }

    /// Matrix equality with different matrices
    func testMatrixInequality() {
        let a = Matrix([[1, 2, 3, 4],
                        [5, 6, 7, 8],
                        [9, 8, 7, 6],
                        [5, 4, 3, 2]])
        let b = Matrix([[2, 3, 4, 5],
                        [6, 7, 8, 9],
                        [8, 7, 6, 5],
                        [4, 3, 2, 1]])
        XCTAssertNotEqual(a, b)
    }

    /// Multiplying two matrices
    func testMatrixMultiplication() {
        let a = Matrix([[1, 2, 3, 4],
                        [5, 6, 7, 8],
                        [9, 8, 7, 6],
                        [5, 4, 3, 2]])
        let b = Matrix([[-2, 1, 2, 3],
                        [3, 2, 1, -1],
                        [4, 3, 6, 5],
                        [1, 2, 7, 8]])
        XCTAssertEqual(a * b, Matrix([[20, 22, 50, 48],
                                      [44, 54, 114, 108 ],
                                      [40, 58, 110, 102 ],
                                      [16, 26, 46, 42 ]]))
    }

    /// A matrix multiplied by a tuple
    func testMultiplyingMatrixByTuple() {
        let a = Matrix([[1, 2, 3, 4],
                        [2, 4, 4, 2],
                        [8, 6, 4, 1],
                        [0, 0, 0, 1]])
        let b = Tuple(x: 1, y: 2, z: 3, w: 1)
        XCTAssertEqual(a * b, Tuple(x: 18, y: 24, z: 33, w: 1))
    }

    /// Multiplying a matrix by the identity matrix
    func testMultiplyingMatrixByIdentity() {
        let a = Matrix([[0, 1, 2, 4],
                        [1, 2, 4, 8],
                        [2, 4, 8, 16],
                        [4, 8, 16, 32]])
        XCTAssertEqual(a * .identity, a)
    }

    /// Multiplying the identity matrix by a tuple
    func testMultiplyingTupleByIdentity() {
        let a = Tuple(x: 1, y: 2, z: 3, w: 4)
        XCTAssertEqual(.identity * a, a)
    }

    /// Transposing a matrix
    func testTransposingMatrices() {
        let a = Matrix([[0, 9, 3, 0],
                        [9, 8, 0, 8],
                        [1, 8, 5, 3],
                        [0, 0, 5, 8]])
        XCTAssertEqual(a.transposed, Matrix([[0, 9, 1, 0],
                                             [9, 8, 8, 0],
                                             [3, 0, 5, 5],
                                             [0, 8, 3, 8]]))
    }
    /// Transposing the identity matrix
    func textTransposingIdentityMatrix() {
        XCTAssertEqual(Matrix.identity.transposed, .identity)
    }

    /// Calculating the determinant of a 2x2 matrix
    func testDeterminant() {
        let a = Matrix([[1, 5],
                        [-3, 2]])
        XCTAssertEqual(a.determinant, 17)
    }

    /// A submatrix of a 3x3 matrix is a 2x2 matrix
    func testSubmatrix3x3to2x2() {
        let a = Matrix([[1, 5, 0],
                        [-3, 2, 7],
                        [ 0, 6, -3]])
        XCTAssertEqual(a.submatrix(row: 0, column: 2), Matrix([[-3, 2],
                                                               [0, 6]]))
    }

    /// A submatrix of a 4x4 matrix is a 3x3 matrix
    func testSubmatrix4x4to3x3() {
        let a = Matrix([[-6, 1, 1, 6],
                        [-8, 5, 8, 6],
                        [-1, 0, 8, 2],
                        [-7, 1, -1, 1]])
        XCTAssertEqual(a.submatrix(row: 2, column: 1), Matrix([[-6, 1, 6],
                                                               [-8, 8, 6],
                                                               [-7, -1, 1]]))
    }

    /// Calculating a minor of a 3x3 matrix
    func testMinor3x3() {
        let a = Matrix([[3, 5, 0],
                        [2, -1, -7],
                        [6, -1, 5]])
        let b = a.submatrix(row: 1, column: 0)
        XCTAssertEqual(b.determinant, 25)
        XCTAssertEqual(a.minor(row: 1, column: 0), 25)
    }

    /// Calculating a cofactor of a 3x3 matrix
    func testCofactor3x3() {
        let a = Matrix([[3, 5, 0],
                        [2, -1, -7],
                        [6, -1, 5]])
        XCTAssertEqual(a.minor(row: 0, column: 0), -12)
        XCTAssertEqual(a.cofactor(row: 0, column: 0), -12)
        XCTAssertEqual(a.minor(row: 1, column: 0), 25)
        XCTAssertEqual(a.cofactor(row: 1, column: 0), -25)
    }

    /// Calculating the determinant of a 3x3 matrix
    func testDeterminant3x3() {
        let a = Matrix([[1, 2, 6],
                        [-5, 8, -4],
                        [2, 6, 4]])
        XCTAssertEqual(a.cofactor(row: 0, column: 0), 56)
        XCTAssertEqual(a.cofactor(row: 0, column: 1), 12)
        XCTAssertEqual(a.cofactor(row: 0, column: 2), -46)
        XCTAssertEqual(a.determinant, -196)
    }

    /// Calculating the determinant of a 4x4 matrix
    func testDeterminant4x4() {
        let a = Matrix([[-2, -8, 3, 5],
                        [-3, 1, 7, 3],
                        [1, 2, -9, 6],
                        [-6, 7, 7, -9]])
        XCTAssertEqual(a.cofactor(row: 0, column: 0), 690)
        XCTAssertEqual(a.cofactor(row: 0, column: 1), 447)
        XCTAssertEqual(a.cofactor(row: 0, column: 2), 210)
        XCTAssertEqual(a.cofactor(row: 0, column: 3), 51)
        XCTAssertEqual(a.determinant, -4071)
    }

    /// Testing an invertible matrix for invertibility
    func testCheckingInvertibleMatrixForInvertibility() {
        let a = Matrix([[6, 4, 4, 4],
                        [5, 5, 7, 6],
                        [4, -9, 3, -7],
                        [ 9, 1, 7, -6]])
        XCTAssertEqual(a.determinant, -2120)
        XCTAssertNotNil(a.inverse)
    }

    /// Testing a non-invertible matrix for invertibility
    func testCheckingNonInvertibleMatrixForInvertibility() {
        let a = Matrix([[-4, 2, -2, -3],
                        [9, 6, 2, 6],
                        [0, -5, 1, -5],
                        [0, 0, 0, 0]])
        XCTAssertEqual(a.determinant, 0)
        XCTAssertNil(a.inverse)
    }

    /// Calculating the inverse of a matrix
    func testMatrixInversion() {
        let a = Matrix([[-5, 2, 6, -8],
                        [1, -5, 1, 8],
                        [ 7, 7, -6, -7],
                        [1, -3, 7, 4]])
        let b = a.inverse
        XCTAssertEqual(a.determinant, 532)
        XCTAssertEqual(a.cofactor(row: 2, column: 3), -160)
        XCTAssertEqual(b?[row: 3, column: 2], -160/532)
        XCTAssertEqual(a.cofactor(row: 3, column: 2), 105)
        XCTAssertEqual(b?[row: 2, column: 3], 105/532)
        let invertedA = Matrix([[0.21804512, 0.45112783, 0.24060151, -0.04511278],
                                [-0.8082707, -1.456767, -0.44360903, 0.5206767],
                                [-0.078947365, -0.2236842, -0.05263158, 0.19736843],
                                [-0.52255636, -0.81390977, -0.30075186, 0.30639097]])
        XCTAssertEqual(b, invertedA)
    }

    /// Calculating the inverse of another matrix
    func testAnotherMatrixInversion() {
        let a = Matrix([[8, -5, 9, 2],
                        [7, 5, 6, 1],
                        [-6, 0, 9, 6],
                        [-3, 0, -9, -4]])
        let invertedA = Matrix([[-0.15384616, -0.15384616, -0.2820513, -0.53846157],
                                [-0.07692308, 0.12307692, 0.025641026, 0.03076923],
                                [0.35897437, 0.35897437, 0.43589744, 0.9230769],
                                [-0.6923077, -0.6923077, -0.7692308, -1.9230769]])
        XCTAssertEqual(a.inverse, invertedA)
    }

    /// Calculating the inverse of a third matrix
    func testThirdMatrixInversion() {
        let a = Matrix([[9, 3, 0, 9],
                        [-5, -2, -6, -3],
                        [-4, 9, 6, 4],
                        [-7, 6, 6, 2]])
        let invertedA = Matrix([[-0.04074074, -0.07777778, 0.14444445, -0.22222222],
                                [-0.07777778, 0.033333335, 0.36666667, -0.33333334],
                                [-0.029012345, -0.14629629, -0.10925926, 0.12962963],
                                [0.17777778, 0.06666667, -0.26666668, 0.33333334]])
        XCTAssertEqual(a.inverse, invertedA)
    }

    /// Multiplying a product by its inverse
    func testMultiplyingProducyByInverse() {
        let a = Matrix([[3, -9, 7, 3],
                        [3, -8, 2, -9],
                        [-4, 4, 4, 1],
                        [-6, 5, -1, 1]])
        let b = Matrix([[8, 2, 2, 2],
                        [3, -1, 7, 0],
                        [7, 0, 5, 4],
                        [6, -2, 0, 5]])
        let c = a * b
        XCTAssertEqual(c * b.inverse!, a)
    }
}

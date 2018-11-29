import XCTest
@testable import RaytracerChallenge

/// Feature: Tuples, Vectors, and Points
class TestTuples: XCTestCase {
    /// A tuple with w=1.0 is a point
    func testPoint() {
        let a = Tuple(x: 4.3, y: -4.2, z: 3.1, w: 1)
        XCTAssertEqual(a.x, 4.3, accuracy: .epsilon)
        XCTAssertEqual(a.y, -4.2, accuracy: .epsilon)
        XCTAssertEqual(a.z, 3.1, accuracy: .epsilon)
        XCTAssertEqual(a.w, 1, accuracy: .epsilon)
        XCTAssertTrue(a.isPoint)
        XCTAssertFalse(a.isVector)
    }

    /// A tuple with w=0 is a vector
    func testVector() {
        let a = Tuple(x: 4.3, y: -4.2, z: 3.1, w: 0)
        XCTAssertEqual(a.x, 4.3, accuracy: .epsilon)
        XCTAssertEqual(a.y, -4.2, accuracy: .epsilon)
        XCTAssertEqual(a.z, 3.1, accuracy: .epsilon)
        XCTAssertEqual(a.w, 0, accuracy: .epsilon)
        XCTAssertFalse(a.isPoint)
        XCTAssertTrue(a.isVector)
    }

    /// Tuple.point() creates tuples with w=1
    func testPointConstructor() {
        let p: Tuple = .point(x: 4, y: -4, z: 3)
        XCTAssertEqual(p, Tuple(x: 4, y: -4, z: 3, w: 1))
        XCTAssertTrue(p.isPoint)
        XCTAssertFalse(p.isVector)
    }

    /// Tuple.vector() creates tuples with w=0
    func testVectorConstructor() {
        let v: Tuple = .vector(x: 4, y: -4, z: 3)
        XCTAssertEqual(v, Tuple(x: 4, y: -4, z: 3, w: 0))
        XCTAssertFalse(v.isPoint)
        XCTAssertTrue(v.isVector)
    }

    /// Adding two tuples
    func testAddingTuples() {
        let a1 = Tuple(x: 3, y: -2, z: 5, w: 1)
        let a2 = Tuple(x: -2, y: 3, z: 1, w: 0)
        XCTAssertEqual(a1 + a2, Tuple(x: 1, y: 1, z: 6, w: 1))
    }

    /// Subtracting two points
    func testSubtractingPoints() {
        let p1 = Tuple.point(x: 3, y: 2, z: 1)
        let p2 = Tuple.point(x: 5, y: 6, z: 7)
        XCTAssertEqual(p1 - p2, .vector(x: -2, y: -4, z: -6))
    }

    /// Subtracting a vector from a point
    func testSubtractingVectorFromPoint() {
        let p = Tuple.point(x: 3, y: 2, z: 1)
        let v = Tuple.vector(x: 5, y: 6, z: 7)
        XCTAssertEqual(p - v, .point(x: -2, y: -4, z: -6))
    }

    /// Subtracting two vectors
    func testSubtractingVectors() {
        let v1 = Tuple.vector(x: 3, y: 2, z: 1)
        let v2 = Tuple.vector(x: 5, y: 6, z: 7)
        XCTAssertEqual(v1 - v2, .vector(x: -2, y: -4, z: -6))
    }

    /// Subtracting a vector from the zero vector
    func testSubtractingFromZeroVector() {
        let v = Tuple.vector(x: 1, y: -2, z: 3)
        XCTAssertEqual(.zeroVector - v, .vector(x: -1, y: 2, z: -3))
    }

    /// Negating a tuple
    func testNegatingTuple() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(-a, Tuple(x: -1, y: 2, z: -3, w: 4))
        XCTAssertEqual(-a, .zeroVector - a)
    }

    /// Multiplying a tuple by a scalar
    func testMultiplingTupleByScalar() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a * 3.5, Tuple(x: 3.5, y: -7, z: 10.5, w: -14))
    }

    /// Multiplying a tuple by a fraction
    func testMultiplingTupleByFraction() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a * 0.5, Tuple(x: 0.5, y: -1, z: 1.5, w: -2))
    }

    /// Dividing a tuple by a scalar
    func testDividingTupleByScalar() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a / 2, Tuple(x: 0.5, y: -1, z: 1.5, w: -2))
        XCTAssertEqual(a / 2, a * 0.5)
    }

    /// Testing magnitude
    func testMagnitude() {
        XCTAssertEqual(Tuple.vector(x: 1, y: 0, z: 0).magnitude, 1)
        XCTAssertEqual(Tuple.vector(x: 0, y: 1, z: 0).magnitude, 1)
        XCTAssertEqual(Tuple.vector(x: 0, y: 1, z: 0).magnitude, 1)
        XCTAssertEqual(Tuple.vector(x: 1, y: 2, z: 3).magnitude, sqrt(14))
        XCTAssertEqual(Tuple.vector(x: -1, y: -2, z: -3).magnitude, sqrt(14))
    }

    /// Testing normalize
    func testNormalize() {
        XCTAssertEqual(Tuple.vector(x: 4, y: 0, z: 0).normalized, .vector(x: 1, y: 0, z: 0))
        XCTAssertEqual(Tuple.vector(x: 4, y: 0, z: 0).normalized.magnitude, 1, accuracy: .epsilon)
        XCTAssertEqual(Tuple.vector(x: 1, y: 2, z: 3).normalized, .vector(x: 0.26726, y: 0.53452, z: 0.80178))
        XCTAssertEqual(Tuple.vector(x: 1, y: 2, z: 3).normalized.magnitude, 1, accuracy: .epsilon)
    }

    /// The dot product of two tuples
    func testDot() {
        let a = Tuple.vector(x: 1, y: 2, z: 3)
        let b = Tuple.vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.dot(b), 20)
    }

    /// The cross product of two vectors
    func testCross() {
        let a = Tuple.vector(x: 1, y: 2, z: 3)
        let b = Tuple.vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(b), .vector(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(a), .vector(x: 1, y: -2, z: 1))
    }

    /// Colors are (red, green, blue) tuples
    func testColor() {
        let c = Color(red: -0.5, green: 0.4, blue: 1.7)
        XCTAssertEqual(c.red, -0.5)
        XCTAssertEqual(c.green, 0.4)
        XCTAssertEqual(c.blue, 1.7)
    }

    /// Adding colors
    func testAddingColors() {
        let c1 = Color(red: 0.9, green: 0.6, blue: 0.75)
        let c2 = Color(red: 0.7, green: 0.1, blue: 0.25)
        XCTAssertEqual(c1 + c2, Color(red: 1.6, green: 0.7, blue: 1))
    }

    /// Subtracting colors
    func testSubtractingColors() {
        let c1 = Color(red: 0.9, green: 0.6, blue: 0.75)
        let c2 = Color(red: 0.7, green: 0.1, blue: 0.25)
        XCTAssertEqual(c1 - c2, Color(red: 0.2, green: 0.5, blue: 0.5))
    }

    /// Multiplying a color by a scalar
    func testMultiplyingColorByScalar() {
        let c = Color(red: 0.2, green: 0.3, blue: 0.4)
        XCTAssertEqual(c * 2, Color(red: 0.4, green: 0.6, blue: 0.8))
    }

    /// Multiplying a color by a color
    func testMultiplyingColorByColor() {
        let c1 = Color(red: 1, green: 0.2, blue: 0.4)
        let c2 = Color(red: 0.9, green: 1, blue: 0.1)
        XCTAssertEqual(c1 * c2, Color(red: 0.9, green: 0.2, blue: 0.04))
    }

    /// Reflecting a vector approaching at 45°
    func testReflectingVectorAt45() {
        let v = Tuple.vector(x: 1, y: -1, z: 0)
        let n = Tuple.vector(x: 0, y: 1, z: 0)
        XCTAssertEqual(v.reflect(n), .vector(x: 1, y: 1, z: 0))
    }

    /// Reflecting a vector off a slanted surface
    func testReflectingVectorAtSlant() {
        let v = Tuple.vector(x: 0, y: -1, z: 0)
        let n = Tuple.vector(x: sqrt(2)/2, y: sqrt(2)/2, z: 0)
        XCTAssertEqual(v.reflect(n), .vector(x: 1, y: 0, z: 0))
    }
}

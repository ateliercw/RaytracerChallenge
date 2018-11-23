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
}

/*
 Scenario: Colors are (red, green, blue) tuples
  Given c ← color(-0.5, 0.4, 1.7)
  Then c.red = -0.5
    And c.green = 0.4
    And c.blue = 1.7

Scenario: Adding colors
  Given c1 ← color(0.9, 0.6, 0.75)
    And c2 ← color(0.7, 0.1, 0.25)
   Then c1 + c2 = color(1.6, 0.7, 1.0)

Scenario: Subtracting colors
  Given c1 ← color(0.9, 0.6, 0.75)
    And c2 ← color(0.7, 0.1, 0.25)
   Then c1 - c2 = color(0.2, 0.5, 0.5)

Scenario: Multiplying a color by a scalar
  Given c ← color(0.2, 0.3, 0.4)
  Then c * 2 = color(0.4, 0.6, 0.8)

Scenario: Multiplying colors
  Given c1 ← color(1, 0.2, 0.4)
    And c2 ← color(0.9, 1, 0.1)
   Then c1 * c2 = color(0.9, 0.2, 0.04)

Scenario: Reflecting a vector approaching at 45°
  Given v ← vector(1, -1, 0)
    And n ← vector(0, 1, 0)
  When r ← reflect(v, n)
  Then r = vector(1, 1, 0)

Scenario: Reflecting a vector off a slanted surface
  Given v ← vector(0, -1, 0)
    And n ← vector(√2/2, √2/2, 0)
  When r ← reflect(v, n)
  Then r = vector(1, 0, 0)
 */

import Foundation
import XCTest

@testable import RaytracerChallenge

class TestMatrixTransformations: XCTestCase {
    /// Multiplying by a translation matrix
    func testMutiplyingByTranslationMatrix() {
        let transform = Matrix.translation(x: 5, y: -3, z: 2)
        let p = Tuple.point(x: -3, y: 4, z: 5)
        XCTAssertEqual(transform * p, .point(x: 2, y: 1, z: 7))
        XCTAssertEqual(Matrix.identity.translated(x: 5, y: -3, z: 2) * p, .point(x: 2, y: 1, z: 7))
    }

    /// Multiplying by the inverse of a translation matrix
    func testMultiplyingByInverseTranslationMatrix() {
        guard let inv = Matrix.translation(x: 5, y: -3, z: 2).inverse else {
            return XCTFail()
        }
        let p = Tuple.point(x: -3, y: 4, z: 5)
        XCTAssertEqual(inv * p, .point(x: -8, y: 7, z: 3))
    }

    /// Translation does not affect vectors
    func testTranslationDoesNotAffectVectors() {
        let transform = Matrix.translation(x: 5, y: -3, z: 2)
        let v = Tuple.vector(x: -3, y: 4, z: 5)
        XCTAssertEqual(transform * v, v)
    }

    /// A scaling matrix applied to a point
    func testScalingMatrixAppledToPoint() {
        let transform = Matrix.scaling(x: 2, y: 3, z: 4)
        let p = Tuple.point(x: -4, y: 6, z: 8)
        XCTAssertEqual(transform * p, .point(x: -8, y: 18, z: 32))
        XCTAssertEqual(Matrix.identity.scaled(x: 2, y: 3, z: 4) * p, .point(x: -8, y: 18, z: 32))
    }

    /// A scaling matrix applied to a vector
    func testScalingMatrixAppledToVector() {
        let transform = Matrix.scaling(x: 2, y: 3, z: 4)
        let v = Tuple.vector(x: -4, y: 6, z: 8)
        XCTAssertEqual(transform * v, .vector(x: -8, y: 18, z: 32))
    }

    /// Multiplying by the inverse of a scaling matrix
    func testMultiplyingTheInverseOfScalingMatrix() {
        guard let inv = Matrix.scaling(x: 2, y: 3, z: 4).inverse else {
            return XCTFail()
        }
        let v = Tuple.vector(x: -4, y: 6, z: 8)
        XCTAssertEqual(inv * v, .vector(x:-2, y:2, z: 2))
    }

    /// Reflection is scaling by a negative value
    func testReflectionIsScalingByNegativeValue() {
        let transform = Matrix.scaling(x: -1, y: 1, z: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: -2, y: 3, z: 4))
    }

    /// Rotating a point around the x axis
    func testRotatingPointAroundXAxis() {
        let p = Tuple.point(x: 0, y: 1, z: 0)
        let halfQuarter = Matrix.rotation(x: .pi / 4)
        let fullQuarter = Matrix.rotation(x: .pi / 2)
        XCTAssertEqual(halfQuarter * p, .point(x: 0, y: sqrt(2)/2, z: sqrt(2)/2))
        XCTAssertEqual(fullQuarter * p, .point(x: 0, y: 0, z: 1))
        XCTAssertEqual(Matrix.identity.rotated(x: .pi / 2) * p, .point(x: 0, y: 0, z: 1))
    }

    /// The inverse of an x-rotation rotates in the opposite direction
    func testInverseXRotationIsReversed() {
        let p = Tuple.point(x: 0, y: 1, z: 0)
        guard let inv = Matrix.rotation(x: .pi / 4).inverse else {
            return XCTFail()
        }
        XCTAssertEqual(inv * p, .point(x: 0, y: sqrt(2)/2, z: -sqrt(2)/2))
    }

    /// Rotating a point around the y axis
    func testRotatingAroundYAxis() {
        let p = Tuple.point(x: 0, y: 0, z: 1)
        let halfQuarter = Matrix.rotation(y: .pi / 4)
        let fullQuarter = Matrix.rotation(y: .pi / 2)
        XCTAssertEqual(halfQuarter * p, .point(x: sqrt(2)/2, y: 0, z: sqrt(2)/2))
        XCTAssertEqual(fullQuarter * p, .point(x: 1, y: 0, z: 0))
        XCTAssertEqual(Matrix.identity.rotated(y: .pi / 2) * p, .point(x: 1, y: 0, z: 0))
    }

    /// Rotating a point around the z axis
    func testRotatingAroundZAxis() {
        let p = Tuple.point(x: 0, y: 1, z: 0)
        let halfQuarter = Matrix.rotation(z: .pi / 4)
        let fullQuarter = Matrix.rotation(z: .pi / 2)
        XCTAssertEqual(halfQuarter * p, .point(x: -sqrt(2)/2, y: sqrt(2)/2, z: 0))
        XCTAssertEqual(fullQuarter * p, .point(x: -1, y: 0, z: 0))
        XCTAssertEqual(Matrix.identity.rotated(z: .pi / 2) * p, .point(x: -1, y: 0, z: 0))
    }

    /// A shearing transformation moves x in proportion to y
    func testShearingXtoY() {
        let transform = Matrix.shearing(xY: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: 5, y: 3, z: 4))
        XCTAssertEqual(Matrix.identity.sheared(xY: 1) * p, .point(x: 5, y: 3, z: 4))
    }

    /// A shearing transformation moves x in proportion to z
    func testShearingXtoZ() {
        let transform = Matrix.shearing(xZ: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: 6, y: 3, z: 4))
        XCTAssertEqual(Matrix.identity.sheared(xZ: 1) * p, .point(x: 6, y: 3, z: 4))
    }

    /// A shearing transformation moves y in proportion to x
    func testShearingYtoX() {
        let transform = Matrix.shearing(yX: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: 2, y: 5, z: 4))
        XCTAssertEqual(Matrix.identity.sheared(yX: 1) * p, .point(x: 2, y: 5, z: 4))
    }

    /// A shearing transformation moves y in proportion to z
    func testShearingYtoZ() {
        let transform = Matrix.shearing(yZ: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: 2, y: 7, z: 4))
        XCTAssertEqual(Matrix.identity.sheared(yZ: 1) * p, .point(x: 2, y: 7, z: 4))
    }

    /// A shearing transformation moves z in proportion to x
    func testShearingZtoX() {
        let transform = Matrix.shearing(zX: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: 2, y: 3, z: 6))
        XCTAssertEqual(Matrix.identity.sheared(zX: 1) * p, .point(x: 2, y: 3, z: 6))
    }

    /// A shearing transformation moves z in proportion to y
    func testShearingZtoY() {
        let transform = Matrix.shearing(zY: 1)
        let p = Tuple.point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, .point(x: 2, y: 3, z: 7))
        XCTAssertEqual(Matrix.identity.sheared(zY: 1) * p, .point(x: 2, y: 3, z: 7))
    }

    /// Individual transformations are applied in sequence
    func testTransformationAppliedInSequence() {
        let p = Tuple.point(x: 1, y: 0, z: 1)
        let a = Matrix.rotation(x: .pi / 2)
        let b = Matrix.scaling(x: 5, y: 5, z: 5)
        let c = Matrix.translation(x: 10, y: 5, z: 7)
        let p2 = a * p
        XCTAssertEqual(p2, .point(x: 1, y: -1, z: 0))
        let p3 = b * p2
        XCTAssertEqual(p3, .point(x: 5, y: -5, z: 0))
        let p4 = c * p3
        XCTAssertEqual(p4, .point(x: 15, y: 0, z: 7))
    }

    /// Chained transformations must be applied in reverse order
    func testChainedTransformationAppliedInReverseOrder() {
        let p = Tuple.point(x: 1, y: 0, z: 1)
        let a = Matrix.rotation(x: .pi / 2)
        let b = Matrix.scaling(x: 5, y: 5, z: 5)
        let c = Matrix.translation(x: 10, y: 5, z: 7)
        XCTAssertEqual(c * b * a * p, .point(x: 15, y: 0, z: 7))
        XCTAssertEqual(Matrix.rotation(x: .pi / 2)
            .scaled(x: 5, y: 5, z: 5)
            .translated(x: 10, y: 5, z: 7) * p, .point(x: 15, y: 0, z: 7))
    }
}
/*
Scenario: The transformation matrix for the default orientation
  Given from ← point(0, 0, 0)
    And to ← point(0, 0, -1)
    And up ← vector(0, 1, 0)
  When t ← view_transform(from, to, up)
  Then t = identity_matrix

Scenario: A view transformation matrix looking in positive z direction
  Given from ← point(0, 0, 0)
    And to ← point(0, 0, 1)
    And up ← vector(0, 1, 0)
  When t ← view_transform(from, to, up)
  Then t = scaling(-1, 1, -1)

Scenario: The view transformation moves the world
  Given from ← point(0, 0, 8)
    And to ← point(0, 0, 0)
    And up ← vector(0, 1, 0)
  When t ← view_transform(from, to, up)
  Then t = translation(0, 0, -8)

Scenario: An arbitrary view transformation
  Given from ← point(1, 3, 2)
    And to ← point(4, -2, 8)
    And up ← vector(1, 1, 0)
  When t ← view_transform(from, to, up)
  Then t is the following 4x4 matrix:
      | -0.50709 | 0.50709 |  0.67612 | -2.36643 |
      |  0.76772 | 0.60609 |  0.12122 | -2.82843 |
      | -0.35857 | 0.59761 | -0.71714 |  0.00000 |
      |  0.00000 | 0.00000 |  0.00000 |  1.00000 |
*/

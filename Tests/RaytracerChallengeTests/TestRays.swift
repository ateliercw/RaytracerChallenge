import Foundation
import XCTest

@testable import RaytracerChallenge

class TestRays: XCTestCase {
    /// Creating and querying a ray
    func testQueryingRay() {
        let origin = Tuple.point(x: 1, y: 2, z: 3)
        let direction = Tuple.vector(x: 4, y: 5, z: 6)
        let r = Ray(origin: origin, direction: direction)
        XCTAssertEqual(r.origin, origin)
        XCTAssertEqual(r.direction, direction)
    }

    /// Computing a point from a distance
    func testComputingPointFromDistance() {
        let r = Ray(origin: .point(x: 2, y: 3, z: 4),
                    direction: .vector(x: 1, y: 0, z: 0))
        XCTAssertEqual(r.position(0), .point(x: 2, y: 3, z: 4))
        XCTAssertEqual(r.position(1), .point(x: 3, y: 3, z: 4))
        XCTAssertEqual(r.position(-1), .point(x: 1, y: 3, z: 4))
        XCTAssertEqual(r.position(2.5), .point(x: 4.5, y: 3, z: 4))
    }

    /// Translating a ray
    func testTranslationRay() {
        let r = Ray(origin: .point(x: 1, y: 2, z: 3),
                    direction: .vector(x: 0, y: 1, z: 0))
        let m = Matrix.translation(x: 3, y: 4, z: 5)
        let r2 = r * m
        XCTAssertEqual(r2, Ray(origin: .point(x: 4, y: 6, z: 8),
                               direction: .vector(x: 0, y: 1, z: 0)))
        XCTAssertNotEqual(r, r2)
    }

    /// Scaling a ray
    func testScalingRay() {
        let r = Ray(origin: .point(x: 1, y: 2, z: 3),
                    direction: .vector(x: 0, y: 1, z: 0))
        let m = Matrix.scaling(x: 2, y: 3, z: 4)
        let r2 = r * m
        XCTAssertEqual(r2, Ray(origin: .point(x: 2, y: 6, z: 12),
                               direction: .vector(x: 0, y: 3, z: 0)))
    }
}

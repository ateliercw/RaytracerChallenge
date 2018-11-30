import Foundation
import XCTest

@testable import RaytracerChallenge

class TestSpheres: XCTestCase {
    /// A ray intersects a sphere at two points
    func testRayIntersectsSphereAtTwoPoints() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let xs = Sphere().intersections(r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].distance, 4)
        XCTAssertEqual(xs[1].distance, 6)
    }

    /// A ray intersects a sphere at a tangent
    func testRayIntersectsSphereAtTangent() {
        let r = Ray(origin: .point(x: 0, y: 1, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let xs = Sphere().intersections(r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].distance, 5)
        XCTAssertEqual(xs[1].distance, 5)
        XCTAssertEqual(xs.first, xs.last)
    }

    /// A ray misses a sphere
    func testRayMissesSphere() {
        let r = Ray(origin: .point(x: 0, y: 2, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        XCTAssertTrue(Sphere().intersections(r).isEmpty)
    }

    /// A ray originates inside a sphere
    func testRayOriginiatesInsideSphere() {
        let r = Ray(origin: .point(x: 0, y: 0, z: 0),
                    direction: .vector(x: 0, y: 0, z: 1))
        let xs = Sphere().intersections(r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].distance, -1)
        XCTAssertEqual(xs[1].distance, 1)
    }

    /// A sphere is behind a ray
    func testRayOriginiatesInFromOfSphere() {
        let r = Ray(origin: .point(x: 0, y: 0, z: 5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let xs = Sphere().intersections(r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].distance, -6)
        XCTAssertEqual(xs[1].distance, -4)
    }

    /// Intersect sets the object on the intersection
    func testIntersectSetsTheObjectOnIntersections() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersections(r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].object as? Sphere, s)
        XCTAssertEqual(xs[1].object as? Sphere, s)
        XCTAssertNotEqual(xs[0].object as? Sphere, Sphere())
    }

    /// A sphere's default transformation
    func testSphereDefaultTransform() {
        XCTAssertEqual(Sphere().transform, .identity)
    }

    /// Changing a sphere's transformation
    func testSphereTransform() {
        var s = Sphere()
        let t = Matrix.translation(x: 2, y: 3, z: 4)
        s.transform = t
        XCTAssertEqual(s.transform, t)
        XCTAssertEqual(Sphere(transform: t).transform, t)
    }

    /// Intersecting a scaled sphere with a ray
    func testIntersectingScaledSphereWithRay() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let s = Sphere(transform: .scaling(x: 2, y: 2, z: 2))
        let xs = s.intersections(r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].distance, 3)
        XCTAssertEqual(xs[1].distance, 7)
    }

    /// Intersecting a translated sphere with a ray
    func testIntersectingTranslatedSphereWithRay() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let s = Sphere(transform: .translation(x: 5, y: 0, z: 0))
        let xs = s.intersections(r)
        XCTAssertTrue(xs.isEmpty)
    }

    /// The normal on a sphere at a point on the x axis
    func testSphereNormalXAxis() {
        let n = Sphere().normal(at: .point(x: 1, y: 0, z: 0))
        XCTAssertEqual(n, .vector(x: 1, y: 0, z: 0))
    }

    /// The normal on a sphere at a point on the y axis
    func testSphereNormalYAxis() {
        let n = Sphere().normal(at: .point(x: 0, y: 1, z: 0))
        XCTAssertEqual(n, .vector(x: 0, y: 1, z: 0))
    }

    /// The normal on a sphere at a point on the z axis
    func testSphereNormalZAxis() {
        let n = Sphere().normal(at: .point(x: 0, y: 0, z: 1))
        XCTAssertEqual(n, .vector(x: 0, y: 0, z: 1))
    }

    /// The normal on a sphere at a non-axial point
    func testSphereNormalNonAxialPoint() {
        let pos: Float = sqrt(3)/3
        let n = Sphere().normal(at: .point(x: pos, y: pos, z: pos))
        XCTAssertEqual(n, .vector(x: pos, y: pos, z: pos))
    }
    /// The normal is a normalized vector
    func testSphereNormalIsNormalizedVector() {
        let pos: Float = sqrt(3)/3
        let n = Sphere().normal(at: .point(x: pos, y: pos, z: pos))
        XCTAssertEqual(n, n.normalized)
    }

    /// Computing the normal on a translated sphere
    func testComputingNormalOnTranslatedSphere() {
        let n = Sphere(transform: .translation(x: 0, y: 1, z: 0))
            .normal(at: .point(x: 0, y: 1.70711, z: -0.70711))
        XCTAssertEqual(n, .vector(x: 0, y: 0.70711, z: -0.70711))
    }

    /// Computing the normal on a transformed sphere
    func testComputingNormalOnTransformedSphere() {
        let t = Matrix.rotation(z: .pi / 5)
            .scaled(x: 1, y: 0.5, z: 1)
        let n = Sphere(transform: t).normal(at: .point(x: 0, y: sqrt(2)/2, z: -sqrt(2)/2))
        XCTAssertEqual(n, .vector(x: 0, y: 0.97014, z: -0.24254))
    }

    /// A sphere has a default material
    func testSphereDefaultMaterial() {
        XCTAssertEqual(Sphere().material, Material())
    }

    /// A sphere may be assigned a material
    func testSphereMaterialAssignment() {
        let m1 = Material(ambient: 0.5)
        var s = Sphere(material: m1)
        XCTAssertEqual(s.material, m1)
        let m2 = Material(ambient: 1)
        s.material = m2
        XCTAssertEqual(s.material, m2)
    }
}
/*
Scenario: A helper for producing a sphere with a glassy material
  Given s ← glass_sphere()
  Then s.transform = identity_matrix
    And s.material.transparency = 1.0
    And s.material.refractive_index = 1.5
*/

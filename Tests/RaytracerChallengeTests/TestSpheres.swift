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
        XCTAssertEqual(xs[0].object.sphere, s)
        XCTAssertEqual(xs[1].object.sphere, s)
        XCTAssertNotEqual(xs[0].object.sphere, Sphere())
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
}
/*
Scenario: The normal on a sphere at a point on the x axis
  Given s ← sphere()
  When n ← normal_at(s, point(1, 0, 0))
  Then n = vector(1, 0, 0)

Scenario: The normal on a sphere at a point on the y axis
  Given s ← sphere()
  When n ← normal_at(s, point(0, 1, 0))
  Then n = vector(0, 1, 0)

Scenario: The normal on a sphere at a point on the z axis
  Given s ← sphere()
  When n ← normal_at(s, point(0, 0, 1))
  Then n = vector(0, 0, 1)

Scenario: The normal on a sphere at a non-axial point
  Given s ← sphere()
  When n ← normal_at(s, point(√3/3, √3/3, √3/3))
  Then n = vector(√3/3, √3/3, √3/3)

Scenario: The normal is a normalized vector
  Given s ← sphere()
  When n ← normal_at(s, point(√3/3, √3/3, √3/3))
  Then n = normalize(n)

Scenario: Computing the normal on a translated sphere
  Given s ← sphere()
    And set_transform(s, translation(0, 1, 0))
  When n ← normal_at(s, point(0, 1.70711, -0.70711))
  Then n = vector(0, 0.70711, -0.70711)

Scenario: Computing the normal on a transformed sphere
  Given s ← sphere()
    And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
    And set_transform(s, m)
  When n ← normal_at(s, point(0, √2/2, -√2/2))
  Then n = vector(0, 0.97014, -0.24254)

Scenario: A sphere has a default material
  Given s ← sphere()
  When m ← s.material
  Then m = material()

Scenario: A sphere may be assigned a material
  Given s ← sphere()
    And m ← material()
    And m.ambient ← 1
  When s.material ← m
  Then s.material = m

Scenario: A helper for producing a sphere with a glassy material
  Given s ← glass_sphere()
  Then s.transform = identity_matrix
    And s.material.transparency = 1.0
    And s.material.refractive_index = 1.5
*/

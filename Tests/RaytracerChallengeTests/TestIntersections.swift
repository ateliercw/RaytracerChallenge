import Foundation
import XCTest

@testable import RaytracerChallenge

class TestIntersections: XCTestCase {
    /// An intersection encapsulates t and object
    func testIntersectionEncapsulatesDistanceAndObject() {
        let s = Sphere()
        let i = Intersection(distance: 3.5, object: s)
        XCTAssertEqual(i.distance, 3.5)
        XCTAssertEqual(i.object as? Sphere, s)
    }

    /// Precomputing the state of an intersection
    func testPrecomputingStateOfIntersection() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5), direction: .vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = Intersection(distance: 4, object: shape)
        let comps = IntersectionState(intersection: i, ray: r)
        XCTAssertEqual(comps.distace, i.distance)
        XCTAssertEqual(comps.object.id, i.object.id)
        XCTAssertEqual(comps.point, .point(x: 0, y: 0, z: -1.0001))
        XCTAssertEqual(comps.eyeV, .vector(x: 0, y: 0, z: -1))
        XCTAssertEqual(comps.normalV, .vector(x: 0, y: 0, z: -1))
    }
/*
Scenario: Precomputing the reflection vector
  Given shape ← plane()
    And r ← ray(point(0, 1, -1), vector(0, -√2/2, √2/2)) 
    And i ← intersection(√2, shape)                      
  When comps ← prepare_computations(i, r)
   Then comps.reflectv = vector(0, √2/2, √2/2)
*/

    /// The hit, when an intersection occurs on the outside
    func testHitWhenIntersectionOccursOutside() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5), direction: .vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = Intersection(distance: 4, object: shape)
        XCTAssertFalse(IntersectionState(intersection: i, ray: r).isInside)
    }

    /// The hit, when an intersection occurs on the inside
    func testHitWhenIntersectionOccursInside() {
        let r = Ray(origin: .point(x: 0, y: 0, z: 0), direction: .vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = Intersection(distance: 1, object: shape)
        let comps = IntersectionState(intersection: i, ray: r)
        XCTAssertEqual(comps.point, .point(x: 0, y: 0, z: 1.0001))
        XCTAssertEqual(comps.eyeV, .vector(x: 0, y: 0, z: -1))
        XCTAssertTrue(comps.isInside)
        XCTAssertEqual(comps.normalV, .vector(x: 0, y: 0, z: -1))
    }

    /// The hit should offset the point
    func testHitShouldOffsetPoint() {
        let r = Ray(origin: .point(x: 0, y: 0, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        let shape = Sphere(transform: .translation(x: 0, y: 0, z: 1))
        let i = Intersection(distance: 5, object: shape)
        let comps = IntersectionState(intersection: i, ray: r)
        XCTAssertTrue(comps.point.z < -.epsilon / 2)
    }
/*
Scenario: The under point is offset below the surface
  Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And shape ← glass_sphere() with:
      | transform | translation(0, 0, 1) |
    And i ← intersection(5, shape)
    And xs ← intersections(i)
  When comps ← prepare_computations(i, r, xs)
  Then comps.under_point.z > EPSILON/2
*/
    /// Aggregating intersections
    func testAggregatingIntersections() {
        let s = Sphere()
        let i1 = Intersection(distance: 1, object: s)
        let i2 = Intersection(distance: 2, object: s)
        let xs = [i1, i2]
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs[0].distance, 1)
        XCTAssertEqual(xs[1].distance, 2)
    }

    /// The hit, when all intersections have positive t
    func testHitContainsAllPositiveDistanceIntersections() {
        let s = Sphere()
        let i1 = Intersection(distance: 1, object: s)
        let i2 = Intersection(distance: 2, object: s)
        let xs = [i1, i2]
        XCTAssertEqual(xs.hit, i1)
    }

    /// The hit, when all intersections have negative t
    func testHitContainsSomeNegativeDistanceIntersections() {
        let s = Sphere()
        let i1 = Intersection(distance: -1, object: s)
        let i2 = Intersection(distance: 1, object: s)
        let xs = [i1, i2]
        XCTAssertEqual(xs.hit, i2)
    }

    /// The hit, when all intersections have negative t
    func testHitContainsAllNegativeDistanceInteractions() {
        let s = Sphere()
        let i1 = Intersection(distance: -2, object: s)
        let i2 = Intersection(distance: -1, object: s)
        let xs = [i1, i2]
        XCTAssertNil(xs.hit)
    }

    ///
    func testHitContainsLowestNonNegativeIntersection() {
        let s = Sphere()

        let i1 = Intersection(distance: 5, object: s)
        let i2 = Intersection(distance: 7, object: s)
        let i3 = Intersection(distance: -3, object: s)
        let i4 = Intersection(distance: 2, object: s)
        let xs = [i1, i2, i3, i4]
        XCTAssertEqual(xs.hit, i4)
    }
/*

Scenario Outline: Finding n1 and n2 at various intersections
  Given A ← glass_sphere() with:
      | transform                 | scaling(2, 2, 2) |
      | material.refractive_index | 1.5              |
    And B ← glass_sphere() with:
      | transform                 | translation(0, 0, -0.25) |
      | material.refractive_index | 2.0                      |
    And C ← glass_sphere() with:
      | transform                 | translation(0, 0, 0.25) |
      | material.refractive_index | 2.5                     |
    And r ← ray(point(0, 0, -4), vector(0, 0, 1))
    And xs ← intersections(2:A, 2.75:B, 3.25:C, 4.75:B, 5.25:C, 6:A)
  When comps ← prepare_computations(xs[<index>], r, xs)  
  Then comps.n1 = <n1>
    And comps.n2 = <n2>             

  Examples:
    | index | n1  | n2  |
    | 0     | 1.0 | 1.5 |                 
    | 1     | 1.5 | 2.0 |
    | 2     | 2.0 | 2.5 |
    | 3     | 2.5 | 2.5 |
    | 4     | 2.5 | 1.5 |
    | 5     | 1.5 | 1.0 |

Scenario: The Schlick approximation under total internal reflection
  Given shape ← glass_sphere()
    And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
    And xs ← intersections(-√2/2:shape, √2/2:shape)
  When comps ← prepare_computations(xs[1], r, xs)
    And reflectance ← schlick(comps)
  Then reflectance = 1.0

Scenario: The Schlick approximation with a perpendicular viewing angle
  Given shape ← glass_sphere()
    And r ← ray(point(0, 0, 0), vector(0, 1, 0))
    And xs ← intersections(-1:shape, 1:shape)
  When comps ← prepare_computations(xs[1], r, xs)
    And reflectance ← schlick(comps)
  Then reflectance = 0.04

Scenario: The Schlick approximation with small angle and n2 > n1
  Given shape ← glass_sphere()
    And r ← ray(point(0, 0.99, -2), vector(0, 0, 1))
    And xs ← intersections(1.8589:shape)
  When comps ← prepare_computations(xs[0], r, xs)
    And reflectance ← schlick(comps)
  Then reflectance = 0.48873

Scenario: An intersection can encapsulate `u` and `v`
  Given s ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
  When i ← intersection_with_uv(3.5, s, 0.2, 0.4)
  Then i.u = 0.2
    And i.v = 0.4
*/
}

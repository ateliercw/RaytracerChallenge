import XCTest
@testable import RaytracerChallenge

private extension World {
    static let defaultWorld: World = {
        let light = PointLight(position: .point(x: -10, y: 10, z: -10), intensity: .white)
        let s1 = Sphere(material: Material(color: Color(red: 0.8, green: 1, blue: 0.6),
                                           diffuse: 0.7,
                                           specular: 0.2))
        let s2 = Sphere(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))
        return World(objects: [s1, s2], lights: [light])
    }()
}

/// Feature: World
class TestWorld: XCTestCase {
    /// Creating a world
    func testCreatingWorld() {
        let w = World()
        XCTAssertTrue(w.objects.isEmpty)
        XCTAssertTrue(w.lights.isEmpty)
    }

    /// The default world
    func testDefaultWorld() {
        let light = PointLight(position: .point(x: -10, y: 10, z: -10), intensity: .white)
        let s1 = Sphere(material: Material(color: Color(red: 0.8, green: 1, blue: 0.6),
                                           diffuse: 0.7,
                                           specular: 0.2))
        let s2 = Sphere(transform: .scaling(x: 0.5, y: 0.5, z: 0.5))
        let w = World.defaultWorld
        XCTAssertEqual(w.lights.first, light)
        XCTAssertTrue(w.objects.contains(where: { $0.material == s1.material}))
        XCTAssertTrue(w.objects.contains(where: { $0.transform == s2.transform}))
    }

    /// Intersect a world with a ray
    func testIntersectingWorldWithRay() {
        let w = World.defaultWorld
        let ray = Ray(origin: .point(x: 0, y: 0, z: -5), direction: .vector(x: 0, y: 0, z: 1))
        let xs = w.intersect(with: ray)
        XCTAssertEqual(xs.count, 4)
        XCTAssertEqual(xs[0].distance, 4, accuracy: .epsilon)
        XCTAssertEqual(xs[1].distance, 4.5, accuracy: .epsilon)
        XCTAssertEqual(xs[2].distance, 5.5, accuracy: .epsilon)
        XCTAssertEqual(xs[3].distance, 6, accuracy: .epsilon)
    }

    /// Shading an intersection
    func testShadingIntersection() {
        let w = World.defaultWorld
        let r = Ray(origin: .point(x: 0, y: 0, z: -5),
                    direction: .vector(x: 0, y: 0, z: 1))
        guard let shape = w.objects.first else { return XCTFail() }
        let i = Intersection(distance: 4, object: shape)
        let comps = IntersectionState(intersection: i, ray: r)
        XCTAssertEqual(w.shadeHit(with: comps), Color(red: 0.38066, green: 0.47583, blue: 0.2855))
    }

    /// Shading an intersection from the inside
    func testShadingIntersectionFromInside() {
        var w = World.defaultWorld
        w.lights = [PointLight(position: .point(x: 0, y: 0.25, z:0), intensity: .white)]
        let r = Ray(origin: .point(x: 0, y: 0, z: 0), direction: .vector(x: 0, y: 0, z: 1))
        guard w.objects.count >= 2 else { return XCTFail() }
        let shape = w.objects[1]
        let i = Intersection(distance: 0.5, object: shape)
        let comps = IntersectionState(intersection: i, ray: r)
        XCTAssertEqual(w.shadeHit(with: comps), Color(red: 0.90498, green: 0.90498, blue: 0.90498))
    }

    /// The color when a ray misses
    func testColorOnRayMiss() {
        let w = World.defaultWorld
        let r = Ray(origin: .point(x: 0, y: 0, z: -5), direction: .vector(x: 0, y: 1, z: 0))
        XCTAssertEqual(w.color(at: r), Color(red: 0, green: 0, blue: 0))
    }

    /// The color when a ray hits
    func testColorOnRayHit() {
        let w = World.defaultWorld
        let r = Ray(origin: .point(x: 0, y: 0, z: -5), direction: .vector(x: 0, y: 0, z: 1))
        XCTAssertEqual(w.color(at: r), Color(red: 0.38066, green: 0.47583, blue: 0.2855))
    }

    /// The color with an intersection behind the ray
    func testColorWithIntersectionBehindRay() {
        var w = World.defaultWorld
        guard w.objects.count >= 2 else { return XCTFail() }
        w.objects[0].material.ambient = 1
        w.objects[1].material.ambient = 1
        let inner = w.objects[1]
        let r = Ray(origin: .point(x: 0, y: 0, z: 0.75), direction: .vector(x: 0, y: 0, z: -1))
        XCTAssertEqual(w.color(at: r), inner.material.color)
    }
 }
/*
Scenario: There is no shadow when nothing is collinear with point and light
  Given w ← default_world()
    And p ← point(0, 10, 0)
   Then is_shadowed(w, p) is false

Scenario: The shadow when an object is between the point and the light
  Given w ← default_world()
    And p ← point(10, -10, 10)
   Then is_shadowed(w, p) is true

Scenario: There is no shadow when an object is behind the light
  Given w ← default_world()
    And p ← point(-20, 20, -20)
   Then is_shadowed(w, p) is false

Scenario: There is no shadow when an object is behind the point
  Given w ← default_world()
    And p ← point(-2, 2, -2)
   Then is_shadowed(w, p) is false

Scenario: shade_hit() is given an intersection in shadow
  Given w ← world()
    And w.light ← point_light(point(0, 0, -10), color(1, 1, 1))
    And s1 ← sphere()
    And s1 is added to w
    And s2 ← sphere() with:
      | transform | translation(0, 0, 10) |
    And s2 is added to w
    And r ← ray(point(0, 0, 5), vector(0, 0, 1))
    And i ← intersection(4, s2)
  When comps ← prepare_computations(i, r)
    And c ← shade_hit(w, comps)
  Then c = color(0.1, 0.1, 0.1)

Scenario: The reflected color for a non-reflective material
  Given w ← default_world()
    And r ← ray(point(0, 0, 0), vector(0, 0, 1))
    And shape ← the second object in w
    And shape.material.ambient ← 1
    And i ← intersection(1, shape)
  When comps ← prepare_computations(i, r)
    And color ← reflected_color(w, comps)
  Then color = color(0, 0, 0)

Scenario: The reflected color for a reflective material
  Given w ← default_world()
    And shape ← plane() with:
      | material.reflective | 0.5                   |
      | transform           | translation(0, -1, 0) |
    And shape is added to w
    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    And i ← intersection(√2, shape)
  When comps ← prepare_computations(i, r)
    And color ← reflected_color(w, comps)
  Then color = color(0.19032, 0.2379, 0.14274)

Scenario: shade_hit() with a reflective material
  Given w ← default_world()
    And shape ← plane() with:
      | material.reflective | 0.5                   |
      | transform           | translation(0, -1, 0) |
    And shape is added to w
    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    And i ← intersection(√2, shape)
  When comps ← prepare_computations(i, r)
    And color ← shade_hit(w, comps)
  Then color = color(0.87677, 0.92436, 0.82918)

Scenario: color_at() with mutually reflective surfaces
  Given w ← world()
    And w.light ← point_light(point(0, 0, 0), color(1, 1, 1))
    And lower ← plane() with:
      | material.reflective | 1                     |
      | transform           | translation(0, -1, 0) |
    And lower is added to w
    And upper ← plane() with:
      | material.reflective | 1                    |
      | transform           | translation(0, 1, 0) |
    And upper is added to w
    And r ← ray(point(0, 0, 0), vector(0, 1, 0))
  Then color_at(w, r) should terminate successfully

Scenario: The reflected color at the maximum recursive depth
  Given w ← default_world()
    And shape ← plane() with:
      | material.reflective | 0.5                   |
      | transform           | translation(0, -1, 0) |
    And shape is added to w
    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    And i ← intersection(√2, shape)
  When comps ← prepare_computations(i, r)
    And color ← reflected_color(w, comps, 0)
  Then color = color(0, 0, 0)

Scenario: The refracted color with an opaque surface
  Given w ← default_world()
    And shape ← the first object in w
    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And xs ← intersections(4:shape, 6:shape)
  When comps ← prepare_computations(xs[0], r, xs)
    And c ← refracted_color(w, comps, 5)
  Then c = color(0, 0, 0)

Scenario: The refracted color at the maximum recursive depth
  Given w ← default_world()
    And shape ← the first object in w
    And shape has:
      | material.transparency     | 1.0 |
      | material.refractive_index | 1.5 |
    And r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And xs ← intersections(4:shape, 6:shape)
  When comps ← prepare_computations(xs[0], r, xs)
    And c ← refracted_color(w, comps, 0)
  Then c = color(0, 0, 0)

Scenario: The refracted color under total internal reflection
  Given w ← default_world()
    And shape ← the first object in w
    And shape has:
      | material.transparency     | 1.0 |
      | material.refractive_index | 1.5 |
    And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
    And xs ← intersections(-√2/2:shape, √2/2:shape)
  # NOTE: this time you're inside the sphere, so you need
  # to look at the second intersection, xs[1], not xs[0]
  When comps ← prepare_computations(xs[1], r, xs)
    And c ← refracted_color(w, comps, 5)
  Then c = color(0, 0, 0)

Scenario: The refracted color with a refracted ray
  Given w ← default_world()
    And A ← the first object in w
    And A has:
      | material.ambient | 1.0            |
      | material.pattern | test_pattern() |
    And B ← the second object in w
    And B has:
      | material.transparency     | 1.0 |
      | material.refractive_index | 1.5 |
    And r ← ray(point(0, 0, 0.1), vector(0, 1, 0))
    And xs ← intersections(-0.9899:A, -0.4899:B, 0.4899:B, 0.9899:A)
  When comps ← prepare_computations(xs[2], r, xs)
    And c ← refracted_color(w, comps, 5)
  Then c = color(0, 0.99878, 0.04724)

Scenario: shade_hit() with a transparent material
  Given w ← default_world()
    And floor ← plane() with:
      | transform                 | translation(0, -1, 0) |
      | material.transparency     | 0.5                   |
      | material.refractive_index | 1.5                   |
    And floor is added to w
    And ball ← sphere() with:
      | material.color     | (1, 0, 0)                  |
      | material.ambient   | 0.5                        |
      | transform          | translation(0, -3.5, -0.5) |
    And ball is added to w
    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    And xs ← intersections(√2:floor)
  When comps ← prepare_computations(xs[0], r, xs)
    And color ← shade_hit(w, comps, 5)
  Then color = color(0.93642, 0.68642, 0.68642)

Scenario: shade_hit() with a reflective, transparent material
  Given w ← default_world()
    And r ← ray(point(0, 0, -3), vector(0, -√2/2, √2/2))
    And floor ← plane() with:
      | transform                 | translation(0, -1, 0) |
      | material.reflective       | 0.5                   |
      | material.transparency     | 0.5                   |
      | material.refractive_index | 1.5                   |
    And floor is added to w
    And ball ← sphere() with:
      | material.color     | (1, 0, 0)                  |
      | material.ambient   | 0.5                        |
      | transform          | translation(0, -3.5, -0.5) |
    And ball is added to w
    And xs ← intersections(√2:floor)
  When comps ← prepare_computations(xs[0], r, xs)
    And color ← shade_hit(w, comps, 5)
  Then color = color(0.93391, 0.69643, 0.69243)
*/

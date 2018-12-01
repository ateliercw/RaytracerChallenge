import XCTest
@testable import RaytracerChallenge

/// Feature: Materials
class MaterialsTests: XCTestCase {
    private let m = Material()
    private let position = Tuple.origin

    /// The default material
    func testDefaultMaterial() {
        let m = Material()
        XCTAssertEqual(m.color, Color(red: 1, green: 1, blue: 1))
        XCTAssertEqual(m.ambient, 0.1)
        XCTAssertEqual(m.diffuse, 0.9)
        XCTAssertEqual(m.specular, 0.9)
        XCTAssertEqual(m.shininess, 200)
    }
/*
Scenario: Reflectivity for the default material
  Given m ← material()
  Then m.reflective = 0.0

Scenario: Transparency and Refractive Index for the default material
  Given m ← material()
  Then m.transparency = 0.0
    And m.refractive_index = 1.0
 */

    /// Lighting with the eye between the light and the surface
    func testLightingWithEyeBetweenLightAndSurface() {
        let eyeV = Tuple.vector(x: 0, y: 0, z: -1)
        let normalV = Tuple.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: 0, y: 0, z: -10), intensity: .white)
        let result = m.lighting(light: light,
                                position: position,
                                eyeVector: eyeV,
                                normalVector: normalV,
                                isInShadow: false)
        XCTAssertEqual(result, Color(red: 1.9, green: 1.9, blue: 1.9))
    }

    /// Lighting with the eye between light and surface, eye offset 45°
    func testLightingWithEye45DegreesOffset() {
        let eyeV = Tuple.vector(x: 0, y: sqrt(2)/2, z: -sqrt(2)/2)
        let normalV = Tuple.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: 0, y: 0, z: -10), intensity: .white)
        let result = m.lighting(light: light,
                                position: position,
                                eyeVector: eyeV,
                                normalVector: normalV,
                                isInShadow: false)
        XCTAssertEqual(result, Color(red: 1, green: 1, blue: 1))
    }

    /// Lighting with eye opposite surface, light offset 45°
    func testLightingWithEyeOppositeSurfaceLightOffset45() {
        let eyeV = Tuple.vector(x: 0, y: 0, z: -1)
        let normalV = Tuple.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: 0, y: 10, z: -10), intensity: .white)
        let result = m.lighting(light: light,
                                position: position,
                                eyeVector: eyeV,
                                normalVector: normalV,
                                isInShadow: false)
        XCTAssertEqual(result, Color(red: 0.7364, green: 0.7364, blue: 0.7364))
    }

    /// Lighting with eye in the path of the reflection vector
    func testLightingWithEyeInPathOfReflection() {
        let eyeV = Tuple.vector(x: 0, y: -sqrt(2)/2, z: -sqrt(2)/2)
        let normalV = Tuple.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: 0, y: 10, z: -10), intensity: .white)
        let result = m.lighting(light: light,
                                position: position,
                                eyeVector: eyeV,
                                normalVector: normalV,
                                isInShadow: false)
        XCTAssertEqual(result, Color(red: 1.63638, green: 1.63638, blue: 1.63638))
    }

    /// Lighting with the light behind the surface
    func testLightingWithLightBehindSurface() {
        let eyeV = Tuple.vector(x: 0, y: 0, z: -1)
        let normalV = Tuple.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: 0, y: 0, z: 10), intensity: .white)
        let result = m.lighting(light: light,
                                position: position,
                                eyeVector: eyeV,
                                normalVector: normalV,
                                isInShadow: false)
        XCTAssertEqual(result, Color(red: 0.1, green: 0.1, blue: 0.1))
    }

    /// Lighting with the surface in shadow
    func testLightingWithSurfaceInShadow() {
        let eyeV = Tuple.vector(x: 0, y: 0, z: -1)
        let normalV = Tuple.vector(x: 0, y: 0, z: -1)
        let light = PointLight(position: .point(x: 0, y: 0, z: -10),
                               intensity: .white)
        let result = m.lighting(light: light,
                                position: position,
                                eyeVector: eyeV,
                                normalVector: normalV,
                                isInShadow: true)
        XCTAssertEqual(result, Color(red: 0.1, green: 0.1, blue: 0.1))
    }

/*
Scenario: Lighting with a pattern applied
  Given m.pattern ← stripe_pattern(color(1, 1, 1), color(0, 0, 0))
    And m.ambient ← 1
    And m.diffuse ← 0
    And m.specular ← 0
    And eyev ← vector(0, 0, -1)
    And normalv ← vector(0, 0, -1)
    And light ← point_light(point(0, 0, -10), color(1, 1, 1))
  When c1 ← lighting(m, light, point(0.9, 0, 0), eyev, normalv, false)
    And c2 ← lighting(m, light, point(1.1, 0, 0), eyev, normalv, false)
  Then c1 = color(1, 1, 1)
    And c2 = color(0, 0, 0)
*/
}

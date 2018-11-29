import XCTest
@testable import RaytracerChallenge

/// Feature: Lights
class LightTests: XCTestCase {
    /// A point light has a position and intensity
    func testPointLightHasPositionAndIntensity() {
        let intensity = Color(red: 1, green: 0.5, blue: 1)
        let position = Tuple.point(x: 0, y: 0, z: 0)
        let light = PointLight(position: position, intensity: intensity)
        XCTAssertEqual(light.position, position)
        XCTAssertEqual(light.intensity, intensity)
    }
}

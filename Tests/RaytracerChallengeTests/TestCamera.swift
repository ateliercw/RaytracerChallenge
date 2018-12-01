import XCTest
@testable import RaytracerChallenge

/// Feature: Camera
class CameraTests: XCTestCase {
    /// Constructing a camera
    func testConstructingCamera() {
        let hSize = 160
        let vSize = 120
        let fieldOfView = Float.pi / 2
        let c = Camera(hSize: hSize, vSize: vSize, fieldOfView: fieldOfView)
        XCTAssertEqual(c.hSize, hSize)
        XCTAssertEqual(c.vSize, vSize)
        XCTAssertEqual(c.fieldOfView, fieldOfView)
        XCTAssertEqual(c.transform, .identity)
    }

    /// The pixel size for a horizontal canvas
    func testPixelSizeForHorizontalCanvas() {
        let c = Camera(hSize: 200, vSize: 125, fieldOfView: .pi / 2)
        XCTAssertEqual(c.pixelSize, 0.01, accuracy: .epsilon)
    }

    /// The pixel size for a vertical canvas
    func testPixelSizeForVerticalCanvas() {
        let c = Camera(hSize: 125, vSize: 200, fieldOfView: .pi / 2)
        XCTAssertEqual(c.pixelSize, 0.01, accuracy: .epsilon)
    }

    /// Constructing a ray through the center of the canvas
    func testConstructingRayThroughCenterOfCanvas() {
        let c = Camera(hSize: 201, vSize: 101, fieldOfView: .pi / 2)
        let r = c.rayForPixel(x: 100, y: 50)
        XCTAssertEqual(r.origin, .point(x: 0, y: 0, z: 0))
        XCTAssertEqual(r.direction, .vector(x: 0, y: 0, z: -1))
    }

    /// Constructing a ray through a corner of the canvas
    func testConstructingRayThroughCornerOfCanvas() {
        let c = Camera(hSize: 201, vSize: 101, fieldOfView: .pi / 2)
        let r = c.rayForPixel(x: 0, y: 0)
        XCTAssertEqual(r.origin, .point(x: 0, y: 0, z: 0))
        XCTAssertEqual(r.direction, .vector(x: 0.66519, y: 0.33259, z: -0.66852))
    }

    /// Constructing a ray when the camera is transformed
    func testConstructingRayWhenCameraIsTransformed() {
        var c = Camera(hSize: 201, vSize: 101, fieldOfView: .pi / 2)
        c.transform = Matrix.translation(x: 0, y: -2, z: 5).rotated(y: .pi / 4)
        let r = c.rayForPixel(x: 100, y: 50)
        XCTAssertEqual(r.origin, .point(x: 0, y: 2, z: -5))
        XCTAssertEqual(r.direction, .vector(x: sqrt(2) / 2, y: 0, z: -sqrt(2) / 2))
    }

    ///  Rendering a world with a camera
    func testRenderingWorldWithACamera() {
        let w = World.defaultWorld
        var c = Camera(hSize: 11, vSize: 11, fieldOfView: .pi / 2)
        let from = Tuple.point(x: 0, y: 0, z: -5)
        let to = Tuple.point(x: 0, y: 0, z: 0)
        let up = Tuple.vector(x: 0, y: 1, z: 0)
        c.transform = Matrix(from: from, to: to, up: up)
        let image = c.render(w)
        XCTAssertEqual(image[x: 5, y: 5], Color(red: 0.38066, green: 0.47583, blue: 0.2855))
    }
}

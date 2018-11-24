import XCTest
@testable import RaytracerChallenge

/// Feature: Canvas
class TestCanvas: XCTestCase {
    /// Creating a canvas
    func testCreatingCanvas() {
        let c = Canvas(width: 10, height: 20)
        XCTAssertEqual(c.width, 10)
        XCTAssertEqual(c.height, 20)
        let black = Color(red: 0, green: 0, blue: 0)
        let allBlack = c.pixels.allSatisfy { column in
            column.allSatisfy { $0 == black }
        }
        XCTAssertTrue(allBlack, "All pixels should initalize as black")
    }

    /// Writing pixels to a canvas
    func testWritingPixels() {
        var c = Canvas(width: 10, height: 20)
        let red = Color(red: 1, green: 0, blue: 0)
        c[x: 2, y: 3] = red
        XCTAssertEqual(c[x: 2, y: 3], red)
    }

    /// Constructing the PPM header
    func testPPMHeader() {
        let ppm = PPMGenerator(canvas: Canvas(width: 5, height: 3))
        let header = """
                     P3
                     5 3
                     255
                     """
        let lines = ppm.contents.split(separator: "\n")[0..<3].joined(separator: "\n")
        XCTAssertEqual(lines, header)
    }

    /// Constructing the PPM pixel data
    func testPPMPixels() {
        var c1 = Canvas(width: 5, height: 3)
        c1[x: 0, y: 0] = Color(red: 1.5, green: 0, blue: 0)
        c1[x: 2, y: 1] = Color(red: 0, green: 0.5, blue: 0)
        c1[x: 4, y: 2] = Color(red: -0.5, green: 0, blue: 1)
        let ppm = PPMGenerator(canvas: c1)
        let lines = ppm.contents.split(separator: "\n")[3..<6].joined(separator: "\n")
        let content = """
                      255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                      0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
                      0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
                      """
        XCTAssertEqual(lines, content)
    }

    // Splitting long lines in PPM files
    func testPPMLineSplit() {
        var canvas = Canvas(width: 10, height: 2)
        for x in (0..<canvas.width) {
            for y in (0..<canvas.height) {
                canvas[x: x, y: y] = Color(red: 1, green: 0.8, blue: 0.6)
            }
        }
        let ppm = PPMGenerator(canvas: canvas)
        let lines = ppm.contents.split(separator: "\n")[3..<7].joined(separator: "\n")
        let content =
            """
            255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
            153 255 204 153 255 204 153 255 204 153 255 204 153
            255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
            153 255 204 153 255 204 153 255 204 153 255 204 153
            """
        XCTAssertEqual(lines, content)
    }

    /// PPM files are terminated by a newline
    func testPPMEndsWithNewline() {
        let ppm = PPMGenerator(canvas: Canvas(width: 5, height: 3))
        XCTAssertEqual(ppm.contents.last, "\n")
    }
}

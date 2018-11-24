import Foundation

public struct Canvas {
    var pixels: [[Color]]

    public init(width: Int, height: Int) {
        let row = [Color].init(repeating: Color(red: 0, green: 0, blue: 0), count: width)
        pixels = [[Color]].init(repeating: row, count: height)
    }

    public var width: Int {
        return pixels.first?.count ?? 0
    }

    public var height: Int {
        return pixels.count
    }

    public subscript(x x: Int, y y: Int) -> Color {
        get {
            return pixels[y][x]
        }
        set {
            pixels[y][x] = newValue
        }
    }

    public func validate(x: Int, y: Int) -> Bool {
        return y < pixels.count && x < pixels[y].count
    }
}

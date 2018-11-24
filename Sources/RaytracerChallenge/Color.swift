import Foundation

public struct Color: Equatable {
    public var red: Float
    public var green: Float
    public var blue: Float

    public init(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.red.isEqualTo(rhs.red, epsilon: .epsilon) &&
            lhs.green.isEqualTo(rhs.green, epsilon: .epsilon) &&
            lhs.blue.isEqualTo(rhs.blue, epsilon: .epsilon)
    }

    public static func + (lhs: Color, rhs: Color) -> Color {
        return Color(red: lhs.red + rhs.red,
                     green: lhs.green + rhs.green,
                     blue: lhs.blue + rhs.blue)
    }

    public static func - (lhs: Color, rhs: Color) -> Color {
        return Color(red: lhs.red - rhs.red,
                     green: lhs.green - rhs.green,
                     blue: lhs.blue - rhs.blue)
    }

    public static func * (lhs: Color, rhs: Float) -> Color {
        return Color(red: lhs.red * rhs,
                     green: lhs.green * rhs,
                     blue: lhs.blue * rhs)
    }

    public static func * (lhs: Color, rhs: Color) -> Color {
        return Color(red: lhs.red * rhs.red,
                     green: lhs.green * rhs.green,
                     blue: lhs.blue * rhs.blue)
    }
}

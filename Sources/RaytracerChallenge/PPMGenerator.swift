import Foundation

public class PPMGenerator {
    private let canvas: Canvas

    public init(canvas: Canvas) {
        self.canvas = canvas
    }

    private var header: String {
        return """
        P3
        \(canvas.width) \(canvas.height)
        255
        """
    }

    private var body: String {
        let lines = canvas.pixels.map { (row) -> String in
            var newLine = ""
            let ppmRow = row.map { $0.ppmValue.joined(separator: " ") }
            let split = ppmRow.joined(separator: " ").split(on: " ", before: 70)
            newLine.append(split.joined(separator: "\n"))
            return newLine
        }
        return lines.joined(separator: "\n")
    }

    public var contents: String {
        return [header, body, "\n"].joined(separator: "\n")
    }
}

private extension Color {
    var ppmValue: [String] {
        return [red.ppmValue, green.ppmValue, blue.ppmValue]
    }
}

private extension Float {
    var ppmValue: String {
        let range: Float = 255
        let mutiplied = self * range
        let clamped = mutiplied.clamped(0...range)
        return String(Int(clamped.rounded()))
    }

    private func clamped(_ range: ClosedRange<Float>) -> Float {
        return max(range.lowerBound, min(range.upperBound, self))
    }
}

private extension String {
    func split(on separator: String, before index: Int) -> [String] {
        guard self.count > index else { return [self] }
        var elements: [String] = []
        var copy = self
        while copy.count > index {
            var head = copy.prefix(index)
            while head.last != " " {
                head = head.dropLast()
            }
            head = head.dropLast()
            elements.append(String(head))
            copy = String(copy.dropFirst(head.count + 1))
        }
        elements.append(copy)
        return elements
    }
}

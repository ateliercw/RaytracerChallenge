import Foundation

extension Float {
    static let epsilon: Float = 0.00001

    func isEqualTo(_ rhs: Float, epsilon: Float) -> Bool {
        return abs(distance(to: rhs)) < epsilon
    }
}

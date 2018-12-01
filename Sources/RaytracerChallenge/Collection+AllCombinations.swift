import Foundation

func allCombinations<Collection1, Collection2>(_ lhs: Collection1, _ rhs: Collection2)
    -> [(Collection1.Element, Collection2.Element)] where Collection1: Collection, Collection2: Collection {
        return lhs.flatMap { leftItem in
            return rhs.map { (leftItem, $0) }
        }
}

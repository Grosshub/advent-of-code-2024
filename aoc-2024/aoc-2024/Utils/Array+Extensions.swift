//
//  Array+Extensions.swift
//  aoc-2024
//

extension Array where Element: Hashable {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func uniqueElementCount() -> Int {
        return Set(self).count
    }
}

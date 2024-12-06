//
//  Array+Extensions.swift
//  aoc-2024
//

extension Array where Element: Hashable {
    func uniqueElementCount() -> Int {
        return Set(self).count
    }
}

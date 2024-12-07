//
//  Int+Extensions.swift
//  aoc-2024
//

import Foundation

extension Int {
    func concatenated(with other: Int) -> Int {
        let otherDigits = Int(log10(Double(other)) + 1)
        return self * Int(pow(10.0, Double(otherDigits))) + other
    }
}

//
//  Day.swift
//  aoc-2024
//

import Foundation

protocol DayExecutable {
    static func run() -> (part1: DayResult, part2: DayResult)
}

enum DayResult {
    case integer(Int)
    case string(String)
    case error(DayError)
}

enum DayError: Error {
    case notImplemented
}

enum Day: Int {
    case day01 = 1
}

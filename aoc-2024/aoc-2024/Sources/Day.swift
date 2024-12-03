//
//  Day.swift
//  aoc-2024
//

import Foundation

protocol DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult
    static func runPart2(_ input: InputProviding) -> DayResult
}

enum DayResult {
    case integer(Int)
    case string(String)
    case error(DayError)
}

enum DayError: Error {
    case notImplemented
}

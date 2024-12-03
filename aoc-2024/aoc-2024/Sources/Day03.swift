//
//  Day03.swift
//  aoc-2024
//

import Foundation

struct Day03: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        do {
            return .integer(
                try self.calculateMulSum(
                    regexPattern: #"mul\((\d+),(\d+)\)"#,
                    input: input.raw
                )
            )
        } catch {
            return .error(.invalidInput)
        }
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        .error(.notImplemented)
    }
}

extension Day03 {
    private static func calculateMulSum(
        regexPattern: String,
        input: String
    ) throws -> Int {
        let regex = try NSRegularExpression(pattern: regexPattern)
        let matches = regex.matches(
            in: input,
            range: NSRange(input.startIndex..., in: input)
        )
        return matches.reduce(0) { sum, match in
            guard
                let xRange = Range(match.range(at: 1), in: input),
                let yRange = Range(match.range(at: 2), in: input),
                let x = Int(input[xRange]),
                let y = Int(input[yRange])
            else {
                return sum
            }
            return sum + (x * y)
        }
    }
}

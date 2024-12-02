//
//  DayExecutor.swift
//  aoc-2024
//

import Foundation

protocol InputProviding {
    var raw: String { get }
}

// Run solutions for specific day in Advent of Code
struct DayExecutor {
    func run<T: DayExecutable>(
        day: T.Type,
        input: InputProviding
    ) {
        print("\(T.self)")

        let part1Result = self.runPart { T.runPart1(input) }
        print("Result for part 1: \(part1Result.result). Execution time: \(part1Result.time) ms")

        let part2Result = self.runPart { T.runPart2(input) }
        print("Result for part 2: \(part2Result.result). Execution time: \(part2Result.time) ms")
    }

    private func runPart<T>(_ execution: () -> T) -> (result: T, time: String) {
        let start = DispatchTime.now()
        let result = execution()
        let elapsedTime = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
        let formattedTime = String(format: "%.2f", elapsedTime)
        return (result, formattedTime)
    }
}

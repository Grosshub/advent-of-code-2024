//
//  DayExecutor.swift
//  aoc-2024
//

// Run solutions for specific day in Advent of Code
struct DayExecutor {
    func run<T: DayExecutable>(day: T.Type) {
        print("Running \(T.self)")
        let result = T.run()
        print("Result for \(T.self): \(result)")
    }
}

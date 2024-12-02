//
//  DayExecutor.swift
//  aoc-2024
//

protocol InputProviding {
    var raw: String { get }
}

// Run solutions for specific day in Advent of Code
struct DayExecutor {
    func run<T: DayExecutable>(
        day: T.Type,
        input: InputProviding
    ) {
        print("Running \(T.self)")
        let result = T.run(input: input)
        print("Result for \(T.self): \(result)")
    }
}

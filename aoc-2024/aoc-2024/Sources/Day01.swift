//
//  Day01.swift
//  aoc-2024
//

struct Day01: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        let (left, right) = input.raw
            .split(separator: "\n")
            .reduce(into: ([Int](), [Int]())) { result, line in
                let numbers = line
                    .split(separator: " ")
                    .compactMap { Int($0) }
                result.0.append(numbers[0])
                result.1.append(numbers[1])
            }
        let result = zip(left.sorted(), right.sorted())
            .reduce(0) { $0 + abs($1.0 - $1.1) }
        return .integer(result)
    }

    static func runPart2(_ input: InputProviding) -> DayResult {
        // Part 2: write logic here
        return .error(.notImplemented)
    }
}

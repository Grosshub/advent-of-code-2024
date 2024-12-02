//
//  Day01.swift
//  aoc-2024
//

struct Day01: DayExecutable {
    static func run() -> (part1: DayResult, part2: DayResult) {
        let input = self.getInput()
        return (self.solvePart1(input), self.solvePart2(input))
    }

    private static func solvePart1(_ input: String) -> DayResult {
        // Part 1: write logic here
        return .error(.notImplemented)
    }

    private static func solvePart2(_ input: String) -> DayResult {
        // Part 2: write logic here
        return .error(.notImplemented)
    }
}

extension Day01 {
    private static func getInput() -> String {
        return  """
        test
        """
    }
}

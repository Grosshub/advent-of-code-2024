//
//  Day02.swift
//  aoc-2024
//

struct Day02: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        let reports = input.raw
            .split(separator: "\n")
            .map { $0.split(separator: " ").compactMap { Int($0) } }
        return .integer(reports.filter(self.isSafe).count)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        let reports = input.raw
            .split(separator: "\n")
            .map { $0.split(separator: " ").compactMap { Int($0) } }
        return .integer(reports.filter(self.isSafeWithRemoval).count)
    }
}

// MARK: - Helpers

extension Day02 {
    private static func isSafe(_ levels: [Int]) -> Bool {
        let differences = zip(levels, levels.dropFirst()).map { $1 - $0 }
        guard differences.allSatisfy({ abs($0) >= 1 && abs($0) <= 3 }) else {
            return false
        }
        return differences.allSatisfy { $0 > 0 } || differences.allSatisfy { $0 < 0 }
    }
    
    private static func isSafeWithRemoval(_ levels: [Int]) -> Bool {
        if self.isSafe(levels) { return true }
        return levels.indices.contains { index in
            var modifiedLevels = levels
            modifiedLevels.remove(at: index)
            return self.isSafe(modifiedLevels)
        }
    }
}

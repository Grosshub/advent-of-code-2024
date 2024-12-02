//
//  Day02.swift
//  aoc-2024
//

struct Day02: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        let reports = input.raw
            .split(separator: "\n")
            .map { $0.split(separator: " ").compactMap { Int($0) } }
        return .integer(reports.filter(self.isReportSafe).count)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        .error(.notImplemented)
    }

    private static func isReportSafe(_ levels: [Int]) -> Bool {
        let differences = zip(levels, levels.dropFirst()).map { $1 - $0 }
        guard differences.allSatisfy({ abs($0) >= 1 && abs($0) <= 3 }) else {
            return false
        }
        return differences.allSatisfy { $0 > 0 } || differences.allSatisfy { $0 < 0 }
    }
}

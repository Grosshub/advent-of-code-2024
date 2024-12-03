//
//  Day02.swift
//  aoc-2024
//

struct Day02: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        let reports = input.raw
            .split(separator: "\n")
            .map { reportLine in
                reportLine
                    .split(separator: " ")
                    .compactMap { Int($0) }
            }
        return .integer(reports.filter(self.isSafe).count)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        let reports = input.raw
            .split(separator: "\n")
            .map { reportLine in
                reportLine
                    .split(separator: " ")
                    .compactMap { Int($0) }
            }
        return .integer(reports.filter(self.isSafeWithRemoval).count)
    }
}

// MARK: - Helpers

extension Day02 {
    private static func isSafe(_ reports: [Int]) -> Bool {
        let differences = zip(reports, reports.dropFirst()).map { $1 - $0 }
        let withinRange = differences.allSatisfy { abs($0) >= 1 && abs($0) <= 3 }
        return withinRange && (differences.allSatisfy { $0 > 0 } || differences.allSatisfy { $0 < 0 })
    }
    
    private static func isSafeWithRemoval(_ reports: [Int]) -> Bool {
        if self.isSafe(reports) { return true }
        for index in reports.indices {
            var modifiedReports = reports
            modifiedReports.remove(at: index)
            if self.isSafe(modifiedReports) {
                return true
            }
        }
        return false
    }
}

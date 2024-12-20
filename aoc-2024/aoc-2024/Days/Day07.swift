//
//  Day07.swift
//  aoc-2024
//

import Foundation

struct Day07: DayExecutable {
    private static var memo: [String: Bool] = [:]

    static func runPart1(_ input: any InputProviding) -> DayResult {
        .integer(
            self.run(input: input)
        )
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        .integer(
            self.run(input: input, allowConcatenation: true)
        )
    }

    private static func run(
        input: any InputProviding,
        allowConcatenation: Bool = false
    ) -> Int {
        input.raw
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .compactMap { line -> Int? in
                let parts = line
                    .components(separatedBy: ":")
                    .map { $0.trimmingCharacters(in: .whitespaces) }

                guard let targetNumbersPart = parts.first,
                      let numbersListPart = parts.dropFirst().first,
                      let targetNumber = Int(targetNumbersPart)
                else {
                    return nil
                }

                let numbers = numbersListPart
                    .split(separator: " ")
                    .compactMap { Int($0) }

                self.resetMemo()
                return self.canAchieveTarget(
                    from: numbers,
                    targetNumber: targetNumber,
                    allowConcatenation: allowConcatenation,
                    current: numbers[0],
                    index: 1
                )
                ? targetNumber
                : nil
            }
            .reduce(0, +)
    }
}

// MARK: - Helpers

extension Day07 {
    private static func canAchieveTarget(
        from numbers: [Int],
        targetNumber: Int,
        allowConcatenation: Bool,
        current: Int,
        index: Int
    ) -> Bool {
        if index == numbers.count { return current == targetNumber }
        let memoKey = self.makeMemoKey(
            current: current,
            index: index,
            allowConcatenation: allowConcatenation
        )
        if let cachedResult = self.getCachedResult(for: memoKey) { return cachedResult }
        guard let next = numbers[safe: index] else { return false }

        // Addition
        if self.canAchieveTarget(
            from: numbers,
            targetNumber: targetNumber,
            allowConcatenation: allowConcatenation,
            current: current + next,
            index: index + 1
        ) {
            self.cacheResult(true, for: memoKey)
            return true
        }

        // Multiplication
        if self.canAchieveTarget(
            from: numbers,
            targetNumber: targetNumber,
            allowConcatenation: allowConcatenation,
            current: current * next,
            index: index + 1
        ) {
            self.cacheResult(true, for: memoKey)
            return true
        }

        if allowConcatenation {
            // Concatenation
            if self.canAchieveTarget(
                from: numbers,
                targetNumber: targetNumber,
                allowConcatenation: allowConcatenation,
                current: current.concatenated(with: next),
                index: index + 1
            ) {
                self.cacheResult(true, for: memoKey)
                return true
            }
        }

        self.cacheResult(false, for: memoKey)
        return false
    }
}

// MARK: - Memoization

extension Day07 {
    private static func resetMemo() {
        self.memo = [:]
    }

    private static func getCachedResult(
        for key: String
    ) -> Bool? {
        return self.memo[key]
    }

    private static func cacheResult(
        _ result: Bool,
        for key: String
    ) {
        self.memo[key] = result
    }

    private static func makeMemoKey(
        current: Int,
        index: Int,
        allowConcatenation: Bool
    ) -> String {
        return "\(current),\(index),\(allowConcatenation ? 1 : 0)"
    }
}

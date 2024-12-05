//
//  Day05.swift
//  aoc-2024
//

typealias DependencyGraph = [Int: Set<Int>]
typealias PageUpdates = [PageUpdate]
typealias PageUpdate = [Int]

struct Day05: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        let (dependencyGraph, pageUpdates) = self.parse(input: input.raw)
        let middlePageSum = pageUpdates
            .filter {
                self.isValidOrder(
                    pageUpdate: $0,
                    dependencyGraph: dependencyGraph
                )
            }
            .map { $0[$0.count / 2] }
            .reduce(0, +)
        return .integer(middlePageSum)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        .error(.notImplemented)
    }
}

extension Day05 {
    private static func parse(
        input: String
    ) -> (DependencyGraph, PageUpdates) {
        let sections = input.split(separator: "\n\n")
        guard sections.count == 2 else { return ([:], []) }

        let dependencyGraph = sections[0]
            .split(separator: "\n")
            .reduce(into: DependencyGraph()) { graph, rule in
                let pair = rule.split(separator: "|").compactMap { Int($0) }
                guard pair.count == 2 else { return }
                graph[pair[0], default: []].insert(pair[1])
            }

        let pageUpdates = sections[1]
            .split(separator: "\n")
            .map { $0.split(separator: ",").compactMap { Int($0) } }

        return (dependencyGraph, pageUpdates)
    }

    private static func isValidOrder(
        pageUpdate: PageUpdate,
        dependencyGraph: DependencyGraph
    ) -> Bool {
        pageUpdate
            .enumerated()
            .allSatisfy { (pageIndex, earlierPage) in
                pageUpdate[(pageIndex + 1)...].allSatisfy { laterPage in
                    !(dependencyGraph[laterPage]?.contains(earlierPage) ?? false)
                }
            }
    }
}

//
//  Day05.swift
//  aoc-2024
//

typealias DependencyGraph = [Int: Set<Int>]
typealias PageUpdates = [PageUpdate]
typealias PageUpdate = [Int]
typealias DependencyCount = [Int: Int]
typealias DependentPagesMap = [Int: PageUpdate]

struct Day05: DayExecutable {
    static func runPart1(_ input: any InputProviding) -> DayResult {
        let (dependencyGraph, pageUpdates) = self.parse(input.raw)
        let middlePageSum = pageUpdates
            .filter { self.isValidOrder($0, in: dependencyGraph) }
            .map { $0[$0.count / 2] }
            .reduce(0, +)
        return .integer(middlePageSum)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        let (dependencyGraph, pageUpdates) = self.parse(input.raw)
        let sortedMiddlePageSum = pageUpdates
            .filter { !self.isValidOrder($0, in: dependencyGraph) }
            .compactMap { pageUpdate -> Int? in
                let sortedPageUpdate = self.sort(pageUpdate, with: dependencyGraph)
                guard !sortedPageUpdate.isEmpty else { return nil }
                return sortedPageUpdate[sortedPageUpdate.count / 2]
            }
            .reduce(0, +)
        return .integer(sortedMiddlePageSum)
    }
}

extension Day05 {
    private static func parse(
        _ input: String
    ) -> (DependencyGraph, PageUpdates) {
        let inputParts = input.split(separator: "\n\n")
        guard
            let rulesPart = inputParts.first,
            let updatesPart = inputParts.dropFirst().first
        else {
            return (DependencyGraph(), PageUpdates())
        }

        let dependencyGraph = rulesPart
            .split(separator: "\n")
            .reduce(into: DependencyGraph()) { pageDependencies, dependencyRule in
                let dependencyPair = dependencyRule
                    .split(separator: "|")
                    .compactMap { Int($0) }
                guard dependencyPair.count == 2 else { return }
                pageDependencies[dependencyPair[0], default: []].insert(dependencyPair[1])
            }

        let pageUpdates = updatesPart
            .split(separator: "\n")
            .map { $0.split(separator: ",").compactMap { Int($0) } }

        return (dependencyGraph, pageUpdates)
    }

    private static func sort(
        _ pageUpdate: PageUpdate,
        with dependencyGraph: DependencyGraph
    ) -> PageUpdate {
        var dependencyCount: DependencyCount = pageUpdate.reduce(into: [:]) { $0[$1] = 0 }
        var dependentPagesMap = DependentPagesMap()

        pageUpdate.forEach { page in
            dependencyGraph[page]?
                .filter { pageUpdate.contains($0) }
                .forEach { dependency in
                    dependencyCount[dependency, default: 0] += 1
                    dependentPagesMap[page, default: []].append(dependency)
                }
        }

        var readyPages: PageUpdate = pageUpdate.filter { dependencyCount[$0] == 0 }
        var sortedPages: PageUpdate = []

        while let currentPage = readyPages.first {
            readyPages.removeFirst()
            sortedPages.append(currentPage)
            dependentPagesMap[currentPage]?
                .forEach { dependentPage in
                    dependencyCount[dependentPage, default: 0] -= 1
                    if dependencyCount[dependentPage] == 0 {
                        readyPages.append(dependentPage)
                    }
                }
        }

        return sortedPages.count == pageUpdate.count ? sortedPages : []
    }

    private static func isValidOrder(
        _ pageUpdate: PageUpdate,
        in dependencyGraph: DependencyGraph
    ) -> Bool {
        pageUpdate
            .enumerated()
            .allSatisfy { (pageIndex, earlierPage) in
                pageUpdate[(pageIndex + 1)...]
                    .allSatisfy { laterPage in
                        !(dependencyGraph[laterPage]?.contains(earlierPage) ?? false)
                    }
            }
    }
}

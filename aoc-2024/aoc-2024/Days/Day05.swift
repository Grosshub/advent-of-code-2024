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
    static func runPart1(_ input: InputProviding) -> DayResult {
        let (dependencyGraph, pageUpdates) = self.parse(input.raw)
        let middlePageSum = pageUpdates
            .filter { self.isValidOrder($0, dependencyGraph: dependencyGraph) }
            .map { $0[$0.count / 2] }
            .reduce(0, +)
        return .integer(middlePageSum)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        let (dependencyGraph, pageUpdates) = self.parse(input.raw)
        let middlePageSum = pageUpdates
            .filter { !self.isValidOrder($0, dependencyGraph: dependencyGraph) }
            .compactMap { pageUpdate -> Int? in
                let sortedPageUpdate = self.sort(pageUpdate, dependencyGraph: dependencyGraph)
                guard !sortedPageUpdate.isEmpty else { return nil }
                let middlePageIndex = sortedPageUpdate.count / 2
                return sortedPageUpdate[middlePageIndex]
            }
            .reduce(0, +)
        return .integer(middlePageSum)
    }
}

extension Day05 {
    private static func parse(
        _ input: String
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

    private static func sort(
        _ pageUpdate: PageUpdate,
        dependencyGraph: DependencyGraph
    ) -> PageUpdate {
        var dependencyCount: DependencyCount = pageUpdate.reduce(into: [:]) { $0[$1] = 0 }
        var dependentPagesMap: DependentPagesMap = [:]

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
        while !readyPages.isEmpty {
            let currentPage = readyPages.removeFirst()
            sortedPages.append(currentPage)
            if let dependentPages = dependentPagesMap[currentPage] {
                for dependentPage in dependentPages {
                    dependencyCount[dependentPage, default: 0] -= 1
                    if dependencyCount[dependentPage] == 0 {
                        readyPages.append(dependentPage)
                    }
                }
            }
        }
        return sortedPages.count == pageUpdate.count ? sortedPages : []
    }

    private static func isValidOrder(
        _ pageUpdate: PageUpdate,
        dependencyGraph: DependencyGraph
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

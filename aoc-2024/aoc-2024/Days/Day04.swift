//
//  Day04.swift
//  aoc-2024
//

struct Day04: DayExecutable {
    static func runPart1(_ input: InputProviding) -> DayResult {
        let gridRows = input.raw.split(separator: "\n").map(String.init)
        guard !gridRows.isEmpty else { return .error(.invalidInput )}
        return .integer(self.count(word: "XMAS", in: gridRows))
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        .error(.notImplemented)
    }
}

extension Day04 {
    private static func count(
        word: String,
        in gridRows: [String]
    ) -> Int {
        let targetLetters = Array(word)
        let columns = gridRows.first?.count ?? 0
        let directions = [(0, 1), (1, 0), (1, 1), (1, -1), (0, -1), (-1, 0), (-1, -1), (-1, 1)]

        return gridRows.indices.flatMap { rowIndex -> [Int] in
            (0..<columns).flatMap { columnIndex -> [Int] in
                directions.compactMap { direction -> Int? in
                    var coordinates = (x: rowIndex, y: columnIndex)
                    let isMatch = targetLetters.allSatisfy { letter -> Bool in
                        let validPosition = coordinates.x >= 0 && coordinates.x < gridRows.count && coordinates.y >= 0 && coordinates.y < columns
                        guard validPosition && gridRows[coordinates.x][coordinates.y] == letter else { return false }
                        coordinates.x += direction.0
                        coordinates.y += direction.1
                        return true
                    }
                    return isMatch ? 1 : nil
                }
            }
        }.reduce(0, +)
    }
}

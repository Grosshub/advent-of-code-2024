//
//  Day04.swift
//  aoc-2024
//

struct Day04: DayExecutable {
    static func runPart1(_ input: any InputProviding) -> DayResult {
        let gridRows = input.raw.split(separator: "\n").map(String.init)
        guard !gridRows.isEmpty else { return .error(.invalidInput )}
        return .integer(self.count(word: "XMAS", in: gridRows))
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        let gridRows = input.raw.split(separator: "\n").map(String.init)
        guard !gridRows.isEmpty else { return .error(.invalidInput) }
        return .integer(self.countXMASPattern(in: gridRows))
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

        func isWithinBounds(x: Int, y: Int) -> Bool {
            x >= 0 && y >= 0 && x < gridRows.count && y < columns
        }

        func char(x: Int, y: Int) -> Character? {
            guard isWithinBounds(x: x, y: y) else { return nil }
            return gridRows[x][gridRows[x].index(gridRows[x].startIndex, offsetBy: y)]
        }

        func matchesWord(startX: Int, startY: Int, direction: (Int, Int)) -> Bool {
            var coordinates = (x: startX, y: startY)
            return targetLetters.allSatisfy { letter in
                guard
                    let currentChar = char(x: coordinates.x, y: coordinates.y),
                    currentChar == letter
                else {
                    return false
                }
                coordinates.x += direction.0
                coordinates.y += direction.1
                return true
            }
        }

        return gridRows.indices.reduce(0) { totalMatches, rowIndex in
            totalMatches + (0..<columns).reduce(0) { columnMatches, columnIndex in
                columnMatches + directions.filter {
                    matchesWord(startX: rowIndex, startY: columnIndex, direction: $0)
                }.count
            }
        }
    }

    private static func countXMASPattern(
        in gridRows: [String]
    ) -> Int {
        let columns = gridRows.first?.count ?? 0

        func char(x: Int, y: Int) -> Character? {
            guard x >= 0, y >= 0, x < gridRows.count, y < columns else { return nil }
            return gridRows[x][gridRows[x].index(gridRows[x].startIndex, offsetBy: y)]
        }

        func isXMAS(centerX: Int, centerY: Int) -> Bool {
            guard char(x: centerX, y: centerY) == "A" else { return false }

            let topLeft = char(x: centerX - 1, y: centerY - 1)
            let topRight = char(x: centerX - 1, y: centerY + 1)
            let bottomLeft = char(x: centerX + 1, y: centerY - 1)
            let bottomRight = char(x: centerX + 1, y: centerY + 1)

            let pattern1 = (topLeft == "M" && bottomRight == "S") || (topLeft == "S" && bottomRight == "M")
            let pattern2 = (topRight == "M" && bottomLeft == "S") || (topRight == "S" && bottomLeft == "M")
            return pattern1 && pattern2
        }

        return (1..<gridRows.count - 1).reduce(0) { count, centerX in
            count + (1..<columns - 1).filter { centerY in isXMAS(centerX: centerX, centerY: centerY) }.count
        }
    }
}

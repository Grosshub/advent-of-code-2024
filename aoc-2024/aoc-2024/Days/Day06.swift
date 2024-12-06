//
//  Day06.swift
//  aoc-2024
//

struct Day06: DayExecutable {
    static func runPart1(_ input: any InputProviding) -> DayResult {
        let grid = input.raw
            .split(separator: "\n")
            .map { Array($0) }
        guard
            let startPosition = grid.find("^")
        else {
            return .error(.invalidInput)
        }

        let result = self.tracePath(
            from: MovementState(position: startPosition, direction: .up),
            in: grid
        )
        .map { $0.position }
        .uniqueElementCount()

        return .integer(result)
    }

    static func runPart2(_ input: any InputProviding) -> DayResult {
        let grid = input.raw
            .split(separator: "\n")
            .map { Array($0) }

        let result = grid
            .enumerated()
            .flatMap { rowIndex, row in
                row.indices.map { columnIndex in
                    Position(row: rowIndex, column: columnIndex)
                }
            }
            .filter { grid[$0] == "." }
            .filter { self.createsLoop(grid: grid, position: $0) }
            .count

        return .integer(result)
    }
}

// MARK: - Helpers

extension Day06 {
    private static func tracePath(
        from initialState: MovementState,
        in grid: Grid
    ) -> [MovementState] {
        var visitedStates = Set<MovementState>()
        var currentState = initialState
        var path = [MovementState]()

        while visitedStates.insert(currentState).inserted {
            path.append(currentState)

            let nextPosition = currentState.position.move(in: currentState.direction)
            if !grid.isValidPosition(nextPosition) { break }

            if grid.isObstacle(nextPosition) {
                currentState = MovementState(
                    position: currentState.position,
                    direction: currentState.direction.turnRight()
                )
            } else {
                currentState = MovementState(
                    position: nextPosition,
                    direction: currentState.direction
                )
            }
        }
        return path
    }

    private static func createsLoop(
        grid: Grid,
        position: Position
    ) -> Bool {
        guard let startPosition = grid.find("^") else { return false }
        var visitedStates = Set<MovementState>()
        var currentState = MovementState(position: startPosition, direction: .up)

        while true {
            if !visitedStates.insert(currentState).inserted { return true }
            let nextPosition = currentState.position.move(in: currentState.direction)

            if !grid.isValidPosition(nextPosition) { return false }
            if nextPosition == position || grid.isObstacle(nextPosition) {
                currentState = MovementState(
                    position: currentState.position,
                    direction: currentState.direction.turnRight()
                )
            } else {
                currentState = MovementState(
                    position: nextPosition,
                    direction: currentState.direction
                )
            }
        }
    }
}

typealias Grid = [[Character]]

extension Grid {
    subscript(_ position: Position) -> Character? {
        guard self.isValidPosition(position) else { return nil }
        return self[position.row][position.column]
    }

    func isValidPosition(_ position: Position) -> Bool {
        position.row >= 0 && position.row < self.count &&
        position.column >= 0 && position.column < self[0].count
    }

    func isObstacle(_ position: Position) -> Bool {
        self[position] == "#"
    }

    func find(_ target: Character) -> Position? {
        self.enumerated()
            .lazy
            .compactMap { rowIndex, row in
                row.firstIndex(of: target).map { columnIndex in
                    Position(row: rowIndex, column: columnIndex)
                }
            }
            .first
    }
}

struct MovementState: Hashable {
    let position: Position
    let direction: Direction
}

struct Position: Hashable {
    let row: Int
    let column: Int

    func move(in direction: Direction) -> Position {
        Position(
            row: self.row + direction.rowOffset,
            column: self.column + direction.columnOffset
        )
    }
}

enum Direction {
    case up, down, left, right

    var rowOffset: Int {
        switch self {
        case .up: -1
        case .down: 1
        case .left, .right: 0
        }
    }

    var columnOffset: Int {
        switch self {
        case .up, .down: 0
        case .left: -1
        case .right: 1
        }
    }

    func turnRight() -> Direction {
        switch self {
        case .up: return .right
        case .right: return .down
        case .down: return .left
        case .left: return .up
        }
    }
}

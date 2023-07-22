//
//  Direction8.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

enum Direction4: Int, CaseIterable {

    case east
    case south
    case west
    case north

    var coord: Coordinate<Int> { Direction4.coordTable[self] }
    var coordOfAChunk: Coordinate<Int> { Direction4.coordOfAChunkTable[self] }
    var opposite: Direction4 { Direction4.oppositeTable[self] }
    var direction9: [Direction9] { Direction4.direction9Table[self] }

    init?(_ coord: Coordinate<Int>) {
        guard let rawValue = Direction4.rawValue(coord) else {
            return nil
        }

        self.init(rawValue: rawValue)
    }

    // MARK: table
    static let coordTable = [
        Coordinate(1, 0),
        Coordinate(0, -1),
        Coordinate(-1, 0),
        Coordinate(0, 1),
    ]

    static let coordOfAChunkTable = [
        Coordinate(16, 0),
        Coordinate(0, -16),
        Coordinate(-16, 0),
        Coordinate(0, 16),
    ]

    static let oppositeTable: [Direction4] = [
        .west,
        .north,
        .east,
        .south,
    ]

    static let direction9Table: [[Direction9]] = [
        [.northEast, .east, .southEast],
        [.southEast, .south, .southWest],
        [.southWest, .west, .northWest],
        [.northWest, .north, .northEast],
    ]

    static func rawValue(_ coord: Coordinate<Int>) -> Int? {
        var rawValue: Int

        switch (coord.x, coord.y) {
        case (1, 0):
            rawValue = 0
        case (0, -1):
            rawValue = 1
        case (-1, 0):
            rawValue = 2
        case (0, 1):
            rawValue = 3
        default: return nil
        }

        return rawValue
    }

    static func rawValue(_ direction9: Direction9) -> Int? {
        var rawValue: Int

        switch direction9 {
        case .east:
            rawValue = 0
        case .south:
            rawValue = 1
        case .west:
            rawValue = 2
        case .north:
            rawValue = 3
        default: return nil
        }

        return rawValue
    }

}

enum DiagonalDirection4: Int, CaseIterable {

    case northEast
    case southEast
    case southWest
    case northWest

    var coord: Coordinate<Int> { DiagonalDirection4.coordTable[self] }

    static let coordTable = [
        Coordinate(1, 1),
        Coordinate(1, 0),
        Coordinate(0, 0),
        Coordinate(0, 1),
    ]
}

enum Direction8: Int, CaseIterable {

    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest
    case north

    init?(from coord: Coordinate<Int>) {
        guard -1 <= coord.x && coord.x <= 1
                && -1 <= coord.y && coord.y <= 1 else {
            return nil
        }

        let tableIndex = (coord.y - 1) * -3 + (coord.x + 1)
        let rawValue = Direction8.rawValueTable[tableIndex]
        self.init(rawValue: rawValue)
    }

    var coord: Coordinate<Int> {
        Direction8.coordTable[self.rawValue]
    }

    var direction4s: [Direction4] { Direction8.direction4s[self] }

    static var random: Direction8 {
        let rawValue = arc4random_uniform(UInt32(Direction8.allCases.count))

        return Direction8(rawValue: Int(rawValue))!
    }

    static let rawValueTable = [
        6, 7, 0,
        5, 8, 1,
        4, 3, 2,
    ]

    static let coordTable = [
        Coordinate(1, 1),
        Coordinate(1, 0),
        Coordinate(1, -1),
        Coordinate(0, -1),
        Coordinate(-1, -1),
        Coordinate(-1, 0),
        Coordinate(-1, 1),
        Coordinate(0, 1),
    ]

    static func table(_ direction9: Direction9) -> Direction8? {
        var direction: Direction8

        switch direction9 {
        case .southWest:
            direction = .southWest
        case .south:
            direction = .south
        case .southEast:
            direction = .southEast
        case .west:
            direction = .west
        case .east:
            direction = .east
        case .northWest:
            direction = .northWest
        case .north:
            direction = .north
        case .northEast:
            direction = .northEast
        default: return nil
        }

        return direction
    }

    static var direction4s: [[Direction4]] = [
        [.north, .east],
        [.east],
        [.south, .east],
        [.south],
        [.south, .west],
        [.west],
        [.north, .west],
        [.north],
    ]

}

enum Direction9: Int, CaseIterable {

    case southWest
    case south
    case southEast
    case west
    case origin
    case east
    case northWest
    case north
    case northEast

    init?(_ coord: Coordinate<Int>) {
        guard -1 <= coord.x && coord.x <= 1
                && -1 <= coord.y && coord.y <= 1 else {
            return nil
        }

        let rawValue = Direction9.rawValue(coord)
        self.init(rawValue: rawValue)
    }

    var coord: Coordinate<Int> { Direction9.coordTable[self.rawValue] }
    var coordOfAChunk: Coordinate<Int> { Direction9.coordOfAChunkTable[self.rawValue] }

    /// - Parameters:
    ///     - coord: suppose valid
    static func rawValue(_ coord: Coordinate<Int>) -> Int {
        return (coord.y + 1) * 3 + (coord.x + 1)
    }

    static var random: Direction9 {
        let rawValue = arc4random_uniform(UInt32(Direction9.allCases.count))

        return Direction9(rawValue: Int(rawValue))!
    }

    static let coordTable = [
        Coordinate(-1, -1),
        Coordinate(0, -1),
        Coordinate(1, -1),
        Coordinate(-1, 0),
        Coordinate(0, 0),
        Coordinate(1, 0),
        Coordinate(-1, 1),
        Coordinate(0, 1),
        Coordinate(1, 1),
    ]

    static let coordOfAChunkTable = [
        Coordinate(-16, -16),
        Coordinate(0, -16),
        Coordinate(16, -16),
        Coordinate(-16, 0),
        Coordinate(0, 0),
        Coordinate(16, 0),
        Coordinate(-16, 16),
        Coordinate(0, 16),
        Coordinate(16, 16),
    ]

}

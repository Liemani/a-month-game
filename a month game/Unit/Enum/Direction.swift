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

    init?(coord: Coordinate<Int>) {
        var rawValue = 0
        switch (coord.x, coord.y) {
        case (1, 0): rawValue = 0
        case (0, -1): rawValue = 1
        case (-1, 0): rawValue = 2
        case (0, 1): rawValue = 3
        default: return nil
        }
        self.init(rawValue: rawValue)
    }

    var coord: Coordinate<Int> {
        Direction4.coordTable[self.rawValue]
    }

    static let coordTable = [
        Coordinate(1, 0),
        Coordinate(0, -1),
        Coordinate(-1, 0),
        Coordinate(0, 1),
    ]

    var opposite: Direction4 {
        switch self {
        case .east: return .west
        case .south: return .north
        case .west: return .east
        case .north: return .south
        }
    }

    var direction8: [Direction8] {
        switch self {
        case .east: return [.southeast, .east, .northeast]
        case .south: return [.southwest, .south, .southeast]
        case .west: return [.southwest, .west, .northwest]
        case .north: return [.northwest, .north, .northeast]
        }
    }

}

enum Direction8: Int, CaseIterable {

    case southwest
    case south
    case southeast
    case west
    case east
    case northwest
    case north
    case northeast

    init?(coord: Coordinate<Int>) {
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

}

enum Direction9: Int, CaseIterable {

    case southwest
    case south
    case southeast
    case west
    case origin
    case east
    case northwest
    case north
    case northeast

    init?(coord: Coordinate<Int>) {
        guard -1 <= coord.x && coord.x <= 1
                && -1 <= coord.y && coord.y <= 1 else {
            return nil
        }

        let rawValue = (coord.y + 1) * 3 + (coord.x + 1)
        self.init(rawValue: rawValue)
    }

    var coord: Coordinate<Int> {
        Direction9.coordTable[self.rawValue]
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

}

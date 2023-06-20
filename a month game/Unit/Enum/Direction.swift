//
//  Direction8.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

enum Direction4: Int, CaseIterable {

    case East
    case South
    case West
    case North

    init?(coord: Coordinate<Int>) {
        let rawValue = (coord.y == 0) ? (-coord.x + 1) : (coord.y + 2)
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
        case .East: return .West
        case .South: return .North
        case .West: return .East
        case .North: return .South
        }
    }

    var direction8: [Direction8] {
        switch self {
        case .East: return [.SouthEast, .East, .NorthEast]
        case .South: return [.SouthWest, .South, .SouthEast]
        case .West: return [.SouthWest, .West, .NorthWest]
        case .North: return [.NorthWest, .North, .NorthEast]
        }
    }

}

enum Direction8: Int, CaseIterable {

    case SouthWest
    case South
    case SouthEast
    case West
    case East
    case NorthWest
    case North
    case NorthEast

    init?(coord: Coordinate<Int>) {
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

    case SouthWest
    case South
    case SouthEast
    case West
    case Origin
    case East
    case NorthWest
    case North
    case NorthEast

    init?(coord: Coordinate<Int>) {
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

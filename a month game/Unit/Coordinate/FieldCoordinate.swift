//
//  FieldCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation

/// Coordinate system structure specifically for tile coordination
struct FieldCoordinate {

    var coord: Coordinate<Int>

    var x: Int { get { return self.coord.x } }
    var y: Int { get { return self.coord.y } }

    // MARK: - init
    init() {
        self.coord = Coordinate<Int>()
    }

    init(from point: CGPoint) {
        let tileSide = Int(Constant.tileWidth)
        let x = (Int(floor(point.x)) - (point.x < 0.0 ? (tileSide - 1) : 0)) / tileSide
        let y = (Int(floor(point.y)) - (point.y < 0.0 ? (tileSide - 1) : 0)) / tileSide
        let fieldCoord = Coordinate(x, y)
        self.coord = fieldCoord + Constant.tileCountOfChunkSide / 2
    }

    init(_ coord: Coordinate<Int>) {
        self.coord = coord
    }

    init(_ x: Int, _ y: Int) {
        self.coord = Coordinate(x, y)
    }

    var fieldPoint: CGPoint {
        let fieldCoord = self.coord.cgPoint + 0.5 - Double(Constant.tileCountOfChunkSide / 2)
        return fieldCoord * Constant.tileWidth
    }

    func isAdjacent(to fieldCoord: FieldCoordinate) -> Bool {
        self.coord.isAdjacent(to: fieldCoord.coord)
    }

    static func + (lhs: FieldCoordinate, rhs: Coordinate<Int>) -> FieldCoordinate {
        return FieldCoordinate(lhs.coord + rhs)
    }

}

extension FieldCoordinate: Equatable {

    static func == (lhs: FieldCoordinate, rhs: FieldCoordinate) -> Bool {
        return lhs.coord == rhs.coord
    }

    static func != (lhs: FieldCoordinate, rhs: FieldCoordinate) -> Bool {
        return !(lhs == rhs)
    }

}

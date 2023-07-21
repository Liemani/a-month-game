//
//  CoordinateConverter.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation

/// Coordinate system structure specifically for tile coordination
struct CoordinateConverter {

    var coord: Coordinate<Int>

    var x: Int { return self.coord.x }
    var y: Int { return self.coord.y }

    var fieldPoint: CGPoint {
        let fieldCoord = self.coord.cgPoint + 0.5 - Double(Constant.tileCountOfChunkSide / 2)
        return fieldCoord * Constant.tileWidth
    }

    // MARK: - init
    init() {
        self.coord = Coordinate<Int>()
    }

    init(_ point: CGPoint) {
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

    func isAdjacent(to fieldCoord: CoordinateConverter) -> Bool {
        self.coord.isAdjacent(to: fieldCoord.coord)
    }

    static func + (lhs: CoordinateConverter, rhs: Coordinate<Int>) -> CoordinateConverter {
        return CoordinateConverter(lhs.coord + rhs)
    }

}

extension CoordinateConverter: Equatable {

    static func == (lhs: CoordinateConverter, rhs: CoordinateConverter) -> Bool {
        return lhs.coord == rhs.coord
    }

    static func != (lhs: CoordinateConverter, rhs: CoordinateConverter) -> Bool {
        return !(lhs == rhs)
    }

}

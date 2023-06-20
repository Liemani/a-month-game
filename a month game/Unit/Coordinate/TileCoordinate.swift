//
//  TileCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation

/// Coordinate system structure specifically for tile coordination
struct TileCoordinate {

    let coord: Coordinate<Int>

    var x: Int { get { return self.coord.x } }
    var y: Int { get { return self.coord.y } }

    init() {
        self.coord = Coordinate<Int>()
    }

    init(from point: CGPoint) {
        let x = Int(point.x) / Int(Constant.tileSide)
        let y = Int(point.y) / Int(Constant.tileSide)
        self.coord = Coordinate(x, y)
    }

    init(_ coord: Coordinate<Int>) {
        self.coord = coord
    }

    init(_ x: Int, _ y: Int) {
        self.coord = Coordinate(x, y)
    }

    var fieldPoint: CGPoint {
        return (self.coord.toCGPoint() + 0.5) * Constant.tileSide
    }

    func isAdjacent(to tileCoordinate: TileCoordinate) -> Bool {
        self.coord.isAdjacent(to: tileCoordinate.coord)
    }

    static func + (lhs: TileCoordinate, rhs: Coordinate<Int>) -> TileCoordinate {
        return TileCoordinate(lhs.coord + rhs)
    }

}

extension TileCoordinate: Equatable {

    static func == (lhs: TileCoordinate, rhs: TileCoordinate) -> Bool {
        return lhs.coord == rhs.coord
    }

    static func != (lhs: TileCoordinate, rhs: TileCoordinate) -> Bool {
        return !(lhs == rhs)
    }

}

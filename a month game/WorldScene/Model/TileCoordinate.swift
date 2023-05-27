//
//  TileCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation

/// Coordinate system structure specifically for tile coordination
struct TileCoordinate {

    var coordinate: Coordinate<Int>

    var x: Int { get { return self.coordinate.x } set { self.coordinate.x = newValue } }
    var y: Int { get { return self.coordinate.y } set { self.coordinate.y = newValue } }

    init() {
        self.coordinate = Coordinate<Int>()
    }

    init(_ x: Int, _ y: Int) {
        self.coordinate = Coordinate(x, y)
    }

    init(from point: CGPoint) {
        let x = Int(point.x) / Int(Constant.tileSide)
        let y = Int(point.y) / Int(Constant.tileSide)
        self.coordinate = Coordinate(x, y)
    }

    var fieldPoint: CGPoint {
        return (self.coordinate.toCGPoint() + 0.5) * Constant.tileSide
    }

    func isAdjacent(with tileCoordinate: TileCoordinate) -> Bool {
        self.coordinate.isAdjacent(to: tileCoordinate.coordinate)
    }

}

extension TileCoordinate: Equatable {

    static func == (lhs: TileCoordinate, rhs: TileCoordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    static func != (lhs: TileCoordinate, rhs: TileCoordinate) -> Bool {
        return !(lhs == rhs)
    }

}

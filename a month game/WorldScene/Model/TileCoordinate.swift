//
//  TileCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation

/// Coordinate system structure specifically for tile coordination
struct TileCoordinate {

    var value: Coordinate<Int>

    var x: Int { get { return self.value.x } set { self.value.x = newValue } }
    var y: Int { get { return self.value.y } set { self.value.y = newValue } }

    init() {
        self.value = Coordinate<Int>()
    }

    init(x: Int, y: Int) {
        self.value = Coordinate<Int>(x: x, y: y)
    }

    init(from point: CGPoint) {
        let x = Int(point.x) / Int(Constant.tileSide)
        let y = Int(point.y) / Int(Constant.tileSide)
        self.value = Coordinate<Int>(x: x, y: y)
    }

    var fieldPoint: CGPoint {
        return (self.value.toCGPoint() + 0.5) * Constant.tileSide
    }

    func isAdjacent(with tileCoordinate: TileCoordinate) -> Bool {
        self.value.isAdjacent(with: tileCoordinate.value)
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

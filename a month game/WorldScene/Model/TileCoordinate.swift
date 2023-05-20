//
//  CharacterCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/19.
//

import Foundation

struct TileCoordinate {

    var x: Int
    var y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    init() {
        self.init(x: 0, y: 0)
    }

    init(_ worldPoint: CGPoint) {
        let x = Int(worldPoint.x) / Int(Constant.tileSide)
        let y = Int(worldPoint.y) / Int(Constant.tileSide)
        self.init(x: x, y: y)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }

    func isAdjacent(coordinate: TileCoordinate) -> Bool {
        let differenceX = self.x - coordinate.x
        let differenceY = self.y - coordinate.y

        return (-1 <= differenceX && differenceX <= 1)
            && (-1 <= differenceY && differenceY <= 1)
    }

    static func == (left: TileCoordinate, right: TileCoordinate) -> Bool {
        return left.x == right.x && left.y == right.y
    }

    static func != (left: TileCoordinate, right: TileCoordinate) -> Bool {
        return !(left == right)
    }

}

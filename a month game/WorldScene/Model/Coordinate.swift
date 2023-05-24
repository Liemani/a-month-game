//
//  CharacterCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/19.
//

import Foundation

struct Coordinate<T> where T: Numeric {

    typealias T = Int

    var x: T
    var y: T

    init(x: T, y: T) {
        self.x = x
        self.y = y
    }

    static func == (lhs: Coordinate<T>, rhs: Coordinate<T>) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    static func != (lhs: Coordinate<T>, rhs: Coordinate<T>) -> Bool {
        return !(lhs == rhs)
    }

}

extension Coordinate<Int> {

    init() {
        self.init(x: T(0), y: T(0))
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x, y: self.y)
    }

    func isAdjacent(coordinate: Coordinate<Int>) -> Bool {
        let differenceX = self.x - coordinate.x
        let differenceY = self.y - coordinate.y

        return (-1 <= differenceX && differenceX <= 1)
        && (-1 <= differenceY && differenceY <= 1)
    }

}

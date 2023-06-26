//
//  CharacterCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/19.
//

import Foundation

struct Coordinate<T> where T: Numeric {

    var x: T
    var y: T

    init() {
        self.x = 0
        self.y = 0
    }

    init(_ x: T, _ y: T) {
        self.x = x
        self.y = y
    }

    static func + (lhs: Coordinate<T>, rhs: Coordinate<T>) -> Coordinate<T> {
        return Coordinate(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    static func - (lhs: Coordinate<T>, rhs: Coordinate<T>) -> Coordinate<T> {
        return Coordinate(lhs.x - rhs.x, lhs.y - rhs.y)
    }

}

extension Coordinate: Equatable {

    static func == (lhs: Coordinate<T>, rhs: Coordinate<T>) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    static func != (lhs: Coordinate<T>, rhs: Coordinate<T>) -> Bool {
        return !(lhs == rhs)
    }
}

extension Coordinate<Int> {

    init() {
        self.init(T(0), T(0))
    }

    var cgPoint: CGPoint { CGPoint(x: self.x, y: self.y) }

    func isAdjacent(to coordinate: Coordinate<Int>) -> Bool {
        let differenceX = self.x - coordinate.x
        let differenceY = self.y - coordinate.y

        return (-1 <= differenceX && differenceX <= 1)
        && (-1 <= differenceY && differenceY <= 1)
    }

    static func + (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x + rhs, lhs.y + rhs)
    }

    static func - (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x - rhs, lhs.y - rhs)
    }

    static func * (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x * rhs, lhs.y * rhs)
    }

    static func / (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x / rhs, lhs.y / rhs)
    }

    static func << (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x << rhs, lhs.y << rhs)
    }

    static func >> (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x >> rhs, lhs.y >> rhs)
    }

    static func & (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x & rhs, lhs.y & rhs)
    }

}

extension Coordinate<Int>: CustomDebugStringConvertible {

    var debugDescription: String {
        return "(\(self.x), \(self.y))"
    }

}

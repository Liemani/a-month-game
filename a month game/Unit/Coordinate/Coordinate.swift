//
//  CharacterCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/19.
//

import Foundation

struct Coordinate<T: Numeric> where T: Hashable {

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

extension Coordinate: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
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
    var coordUInt8: Coordinate<UInt8> {
        return Coordinate<UInt8>(UInt8(truncatingIfNeeded: self.x),
                                 UInt8(truncatingIfNeeded: self.y))
    }

    func isAdjacent(to coordinate: Coordinate<Int>) -> Bool {
        let deltaX = self.x - coordinate.x
        let deltaY = self.y - coordinate.y

        return (-1 <= deltaX && deltaX <= 1)
        && (-1 <= deltaY && deltaY <= 1)
    }

    // MARK: - Coordinate, Int
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

    static func % (lhs: Coordinate<Int>, rhs: Int) -> Coordinate<Int> {
        return Coordinate<Int>(lhs.x % rhs, lhs.y % rhs)
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

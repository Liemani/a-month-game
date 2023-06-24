//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

struct ChunkCoordinate {

    var x: Int32
    var y: Int32
    var street: StreetAddress

    var coord: Coordinate<Int> {
        get { Coordinate<Int>(Int(self.x), Int(self.y)) << 8 + self.street.coord }
        set {
            self.x = Int32(truncatingIfNeeded: x >> 8)
            self.y = Int32(truncatingIfNeeded: y >> 8)
            self.street = StreetAddress(x, y)
        }
    }

    // MARK: - init
    init() {
        self.x = 0
        self.y = 0
        self.street = StreetAddress()
    }

    init(x: Int32, y: Int32, fullStreetAddress: UInt16) {
        self.x = x
        self.y = y
        self.street = StreetAddress(adress: fullStreetAddress)
    }

    init(_ x: Int, _ y: Int) {
        self.x = Int32(truncatingIfNeeded: x >> 8)
        self.y = Int32(truncatingIfNeeded: y >> 8)
        self.street = StreetAddress(x, y)
    }

    // MARK: -
//    static func buildingDirection(from origin: Coordinate<Int>, to destination: Coordinate<Int>) -> Direction9? {
//        let originBuildingCoord = origin >> 4
//        let destinationBuildingCoord = destination >> 4
//
//        let difference = destinationBuildingCoord - originBuildingCoord
//        let direction = Direction9(coord: difference)
//
//        return direction
//    }

    // TODO: performance improvable
    func chunkDirection(to chunkCoord: ChunkCoordinate) -> Direction9? {
        let differenceCoord = chunkCoord.coord - self.coord
        let chunkDirection = Direction9(from: differenceCoord >> 4)
        return chunkDirection
    }

    // MARK: ChunkCoordinate
    static func + (lhs: ChunkCoordinate, rhs: ChunkCoordinate) -> ChunkCoordinate {
        let coord = lhs.coord + rhs.coord
        return ChunkCoordinate(coord.x, coord.y)
    }

    static func += (lhs: inout ChunkCoordinate, rhs: ChunkCoordinate) {
        lhs = lhs + rhs
    }

    // MARK: Coordinate<Int>
    static func + (lhs: ChunkCoordinate, rhs: Coordinate<Int>) -> ChunkCoordinate {
        let coord = lhs.coord + rhs
        return ChunkCoordinate(coord.x, coord.y)
    }

    static func += (lhs: inout ChunkCoordinate, rhs: Coordinate<Int>) {
        lhs = lhs + rhs
    }

    // MARK: Direction9
    static func + (lhs: ChunkCoordinate, rhs: Direction9) -> ChunkCoordinate {
        return lhs + rhs.coord
    }

}

extension ChunkCoordinate: CustomDebugStringConvertible {

    var debugDescription: String {
        return "(\(self.x), \(self.y), \(self.street))"
    }

}

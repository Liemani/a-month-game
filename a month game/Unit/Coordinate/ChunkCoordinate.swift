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
    var address: Address

    var coord: Coordinate<Int> {
        get { Coordinate<Int>(Int(self.x), Int(self.y)) << 8 + self.address.coord }
        set {
            self.x = Int32(truncatingIfNeeded: x >> 8)
            self.y = Int32(truncatingIfNeeded: y >> 8)
            self.address = Address(Int(x), Int(y))
        }
    }

    var chunk: ChunkCoordinate {
        var chunkChunkCoord = self
        chunkChunkCoord.address.tile.setZero()
        return chunkChunkCoord
    }

    func direction(_ direction: Direction9) -> ChunkCoordinate {
        var x = Int(self.x) << 4 | self.address.chunk.coordX
        var y = Int(self.y) << 4 | self.address.chunk.coordY

        let directionCoord = direction.coord
        x += directionCoord.x
        y += directionCoord.y

        return ChunkCoordinate(x, y)
    }

    // MARK: - init
    init() {
        self.x = 0
        self.y = 0
        self.address = Address()
    }

    init(x: Int32, y: Int32, chunkAddress: UInt16) {
        self.x = x
        self.y = y
        self.address = Address(adress: chunkAddress)
    }

    init(_ x: Int, _ y: Int) {
        self.x = Int32(truncatingIfNeeded: x >> 8)
        self.y = Int32(truncatingIfNeeded: y >> 8)
        self.address = Address(x, y)
    }

    // MARK: -
//    static func buildingDirection(from origin: Coordinate<Int>, to destination: Coordinate<Int>) -> Direction9? {
//        let originBuildingCoord = origin >> 4
//        let destinationBuildingCoord = destination >> 4
//
//        let delta = destinationBuildingCoord - originBuildingCoord
//        let direction = Direction9(coord: delta)
//
//        return direction
//    }

    /// Suppose self. and chunkCoord is chunk chunk coordinate
    func chunkDirection9(to chunkCoord: ChunkCoordinate) -> Direction9? {
        let deltaCoord = chunkCoord.chunk.coord - self.chunk.coord
        let chunkDirection = Direction9(from: deltaCoord >> 4)
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

extension ChunkCoordinate: Equatable {

    static func == (lhs: ChunkCoordinate, rhs: ChunkCoordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.address == rhs.address
    }

    static func != (lhs: ChunkCoordinate, rhs: ChunkCoordinate) -> Bool {
        return !(lhs == rhs)
    }

}

extension ChunkCoordinate: CustomDebugStringConvertible {

    var debugDescription: String {
        return "(\(self.x), \(self.y), \(self.address))"
    }

}

//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

struct ChunkCoordinate {

    let x: Int32
    let y: Int32
    let street: UInt8
    let building: UInt8

    // MARK: - init
    init(from chunkCoordMO: ChunkCoordinateMO) {
        self.init(x: chunkCoordMO.x, y: chunkCoordMO.y, location: UInt16(bitPattern: Int16(truncatingIfNeeded: chunkCoordMO.location)))
    }

    init(from coord: Coordinate<Int>) {
        self.init(coord.x, coord.y)
    }

    private init(x: Int32, y: Int32, location: UInt16) {
        let mask:UInt16 = 0xff

        self.x = x
        self.y = y
        self.street = UInt8((location >> 8) & mask)
        self.building = UInt8(location & mask)
    }

    private init(_ x: Int, _ y: Int) {
        self.x = Int32(x >> 8)
        self.y = Int32(y >> 8)

        let mask = 0xf

        let streetX = (x >> 4) & mask
        let streetY = (y >> 4) & mask
        self.street = UInt8((streetX << 4) | streetY)

        let buildingX = x & mask
        let buildingY = y & mask
        self.building = UInt8((buildingX << 4) | buildingY)
    }

    // MARK: -
    var location: Int32 {
        return (Int32(self.street) << 8) | Int32(self.building)
    }

    var coord: Coordinate<Int> {
        let mask = 0xf

        let street = Int(self.street)
        let building = Int(self.building)

        let x = Int(self.x) << 8
            + (((street >> 4) & mask) << 4)
            + ((building >> 4) & mask)
        let y = Int(self.y) << 8
            + ((street & mask) << 4)
            + (building & mask)
        return Coordinate<Int>(x, y)
    }

    static func buildingDirection(from origin: Coordinate<Int>, to destination: Coordinate<Int>) -> Direction9? {
        let originBuildingCoord = origin >> 4
        let destinationBuildingCoord = destination >> 4

        let difference = destinationBuildingCoord - originBuildingCoord
        let direction = Direction9(coord: difference)

        return direction
    }

    static func + (lhs: ChunkCoordinate, rhs: Coordinate<Int>) -> ChunkCoordinate {
        let coord = lhs.coord
        let targetCoord = coord + rhs
        return ChunkCoordinate(from: targetCoord)
    }

}

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
    var street: UInt8
    var building: UInt8

    var streetX: UInt8 { self.street >> 4 }
    var streetY: UInt8 { self.street & 0x0f }
    var buildingX: UInt8 { self.building >> 4 }
    var buildingY: UInt8 { self.building & 0x0f }

    var location: UInt16 { (UInt16(self.street) << 8) | UInt16(self.building) }
    var locationX: UInt8 { (self.street & 0xf0) | (self.building >> 4) }
    var locationY: UInt8 { (self.street << 4) | (self.building & 0x0f) }

    // MARK: - init
    init() {
        self.x = 0
        self.y = 0
        self.street = 0
        self.building = 0
    }

    init(from chunkCoordMO: ChunkCoordinateMO) {
        self.init(x: chunkCoordMO.x, y: chunkCoordMO.y, location: UInt16(truncatingIfNeeded: UInt32(bitPattern: chunkCoordMO.location)))
    }

    init(from coord: Coordinate<Int>) {
        self.init(coord.x, coord.y)
    }

    init(x: Int, y: Int, location: Int) {
        self.x = Int32(x)
        self.y = Int32(y)
        let location = UInt16(truncatingIfNeeded: location)
        self.street = UInt8(location >> 8)
        self.building = UInt8(location & 0xff)
    }

    private init(x: Int32, y: Int32, location: UInt16) {
        self.x = x
        self.y = y
        self.street = UInt8(location >> 8)
        self.building = UInt8(location & 0xff)
    }

    init(_ x: Int, _ y: Int) {
        self.x = Int32(x >> 8)
        self.y = Int32(y >> 8)

        let buildingX = UInt8(truncatingIfNeeded: UInt(bitPattern: x))
        let buildingY = UInt8(truncatingIfNeeded: UInt(bitPattern: y))
        self.street = (buildingX & 0xf0) | (buildingY >> 4)
        self.building = (buildingX << 4) | (buildingY & 0x0f)
    }

    // MARK: -
    var coord: Coordinate<Int> {
        let mask = 0x0f

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

    mutating func update(location: UInt16) {
        self.street = UInt8(location >> 8)
        self.building = UInt8(location & 0xff)
    }

    mutating func update(buildingX: UInt8, buildingY: UInt8) {
        self.street = (buildingX & 0xf0) | (buildingY >> 4)
        self.building = (buildingX << 4) | (buildingY & 0x0f)
    }

//    static func buildingDirection(from origin: Coordinate<Int>, to destination: Coordinate<Int>) -> Direction9? {
//        let originBuildingCoord = origin >> 4
//        let destinationBuildingCoord = destination >> 4
//
//        let difference = destinationBuildingCoord - originBuildingCoord
//        let direction = Direction9(coord: difference)
//
//        return direction
//    }

    func chunkDirection(to chunkCoord: ChunkCoordinate) -> Direction9? {
        let streetDifferenceX = Int(chunkCoord.streetX) - Int(self.streetX)
        let streetDifferenceY = Int(chunkCoord.streetY) - Int(self.streetY)
        let chunkDirection = Direction9(coord: Coordinate(streetDifferenceX, streetDifferenceY))
        return chunkDirection
    }

    static func + (lhs: ChunkCoordinate, rhs: Coordinate<Int>) -> ChunkCoordinate {
        var mutableChunkCoord = lhs

        var locationX = Int(lhs.locationX)
        locationX += rhs.x
        mutableChunkCoord.x += Int32(truncatingIfNeeded: locationX >> 8)
        let buildingX = UInt8(truncatingIfNeeded: UInt(bitPattern: locationX))

        var locationY = Int(lhs.locationY)
        locationY += rhs.y
        mutableChunkCoord.y += Int32(truncatingIfNeeded: locationY >> 8)
        let buildingY = UInt8(truncatingIfNeeded: UInt(bitPattern: locationY))

        mutableChunkCoord.update(buildingX: buildingX, buildingY: buildingY)
        return mutableChunkCoord
    }

    static func + (lhs: ChunkCoordinate, rhs: Direction9) -> ChunkCoordinate {
        return lhs + rhs.coord
    }

}

extension ChunkCoordinate: CustomDebugStringConvertible {

    var debugDescription: String {
        return "(\(self.x), \(self.y), \(self.location))"
    }

}

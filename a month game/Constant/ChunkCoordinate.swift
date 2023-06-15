//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation


struct ChunkCoordinate {

    let chunkX: Int
    let chunkY: Int
    let cityLocation: UInt8
    let streetLocation: UInt8

    init(chunkX: Int, chunkY: Int, chunkLocation: UInt16) {
        let mask:UInt16 = 0xff

        self.chunkX = chunkX
        self.chunkY = chunkY
        self.cityLocation = UInt8((chunkLocation >> 8) & mask)
        self.streetLocation = UInt8(chunkLocation & mask)
    }

    init(goMO: GameObjectMO) {
        self.init(chunkX: Int(goMO.chunkX), chunkY: Int(goMO.chunkY), chunkLocation: UInt16(bitPattern: goMO.chunkLocation))
    }

    init(_ x: Int, _ y: Int) {
        self.chunkX = x >> 8
        self.chunkY = y >> 8

        let mask = 0xf

        let cityLocationX = (x >> 4) & mask
        let cityLocationY = (y >> 4) & mask
        let streetLocationX = x & mask
        let streetLocationY = y & mask
        self.cityLocation = UInt8((cityLocationX << 4) | cityLocationY)
        self.streetLocation = UInt8((streetLocationX << 4) | streetLocationY)
    }

    init(coord: Coordinate<Int>) {
        self.init(coord.x, coord.y)
    }

    var chunkLocation: Int16 {
        return (Int16(self.cityLocation) << 8) | Int16(self.streetLocation)
    }

    var coord: Coordinate<Int> {
        let mask = 0xf

        let cityLocation = Int(self.cityLocation)
        let streetLocation = Int(self.streetLocation)

        let x = self.chunkX << 8
            + (((cityLocation >> 4) & mask) << 4)
            + ((streetLocation >> 4) & mask)
        let y = self.chunkY << 8
            + ((cityLocation & mask) << 4)
            + (streetLocation & mask)
        return Coordinate<Int>(x, y)
    }

}

//
//  StreetChunkCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation

struct Address {
    
    var chunk: AddressComponent
    var tile: AddressComponent

    var value: UInt16 {
        get { UInt16(self.chunk.value) << 8 | UInt16(self.tile.value) }
        set {
            self.chunk = AddressComponent(UInt8(truncatingIfNeeded: newValue >> 8))
            self.tile = AddressComponent(UInt8(newValue & 0xff))
        }
    }

    var coord: Coordinate<Int> {
        get { Coordinate(self.coordX, self.coordY) }
        set {
            let x = UInt8(truncatingIfNeeded: UInt(bitPattern: newValue.x))
            let y = UInt8(truncatingIfNeeded: UInt(bitPattern: newValue.y))
            let chunkAddress = (x & 0xf0) | (y >> 4)
            let tileAddress = (x << 4) | (y & 0x0f)
            self.chunk = AddressComponent(chunkAddress)
            self.tile = AddressComponent(tileAddress)
        }
    }
    var coordX: Int { Int(self.chunk.coordX) << 4 + self.tile.coordX }
    var coordY: Int { Int(self.chunk.coordY) << 4 + self.tile.coordY }

    // MARK: - init
    init() {
        self.chunk = AddressComponent()
        self.tile = AddressComponent()
    }

    init(chunk: AddressComponent, tile: AddressComponent) {
        self.chunk = chunk
        self.tile = tile
    }

    init(adress: UInt16) {
        self.chunk = AddressComponent(UInt8(truncatingIfNeeded: adress >> 8))
        self.tile = AddressComponent(UInt8(adress & 0xff))
    }

    init(_ x: Int, _ y: Int) {
        let x = UInt8(truncatingIfNeeded: UInt(bitPattern: x))
        let y = UInt8(truncatingIfNeeded: UInt(bitPattern: y))
        let chunkAddress = (x & 0xf0) | (y >> 4)
        let tileAddress = (x << 4) | (y & 0x0f)
        self.chunk = AddressComponent(chunkAddress)
        self.tile = AddressComponent(tileAddress)
    }

}

extension Address: CustomDebugStringConvertible {

    var debugDescription: String {
        return "\(self.chunk), (\(self.tile))"
    }

}

//
//  BuildingChunkCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation

struct AddressComponent: Equatable {

    var rawCoord: Coordinate<UInt8>
    var value: UInt8 {
        get { self.rawCoord.x << 4 | self.rawCoord.y }
        set {
            self.rawCoord.x = newValue >> 4
            self.rawCoord.y = newValue & 0xf
        }
    }
    
    var coord: Coordinate<Int> {
        get { Coordinate(self.coordX, self.coordY) }
        set {
            self.rawCoord.x = UInt8(truncatingIfNeeded: newValue.x)
            self.rawCoord.y = UInt8(truncatingIfNeeded: newValue.y)
        }
    }
    var coordX: Int { Int(self.rawCoord.x) }
    var coordY: Int { Int(self.rawCoord.y) }

    // MARK: - init
    init() {
        self.rawCoord = Coordinate<UInt8>()
    }

    init(_ x: UInt8, _ y: UInt8) {
        self.rawCoord = Coordinate<UInt8>(x, y)
    }

    init(_ address: UInt8) {
        self.rawCoord = Coordinate<UInt8>(address >> 4, address & 0xf)
    }

    mutating func setZero() {
        self.rawCoord.x = 0
        self.rawCoord.y = 0
    }

}

extension AddressComponent: CustomDebugStringConvertible {

    var debugDescription: String {
        return "(\(self.rawCoord.x), \(self.rawCoord.y))"
    }

}

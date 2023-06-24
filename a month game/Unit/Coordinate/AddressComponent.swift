//
//  BuildingChunkCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation

struct AddressComponent {

    var x: UInt8
    var y: UInt8
    var address: UInt8 {
        get { self.x << 4 | self.y }
        set {
            self.x = newValue >> 4
            self.y = newValue & 0xf
        }
    }
    
    var coord: Coordinate<Int> {
        get { Coordinate(self.coordX, self.coordY) }
        set {
            self.x = UInt8(truncatingIfNeeded: newValue.x)
            self.y = UInt8(truncatingIfNeeded: newValue.y)
        }
    }
    var coordX: Int { Int(self.x) }
    var coordY: Int { Int(self.y) }

    // MARK: - init
    init() {
        self.x = 0
        self.y = 0
    }

    init(_ x: UInt8, _ y: UInt8) {
        self.x = x
        self.y = y
    }

    init(_ address: UInt8) {
        self.x = address >> 4
        self.y = address & 0xf
    }

}

extension AddressComponent: CustomDebugStringConvertible {

    var debugDescription: String {
        return "(\(self.x), \(self.y))"
    }

}

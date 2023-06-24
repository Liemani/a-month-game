//
//  StreetChunkCoordinate.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation

struct StreetAddress {
    
    var street: AddressComponent
    var building: AddressComponent

    var address: UInt16 {
        get { UInt16(self.street.address) << 8 | UInt16(self.building.address) }
        set {
            self.street = AddressComponent(UInt8(truncatingIfNeeded: newValue >> 8))
            self.building = AddressComponent(UInt8(newValue & 0xff))
        }
    }

    var coord: Coordinate<Int> {
        get { Coordinate(self.coordX, self.coordY) }
        set {
            let x = UInt8(truncatingIfNeeded: UInt(bitPattern: newValue.x))
            let y = UInt8(truncatingIfNeeded: UInt(bitPattern: newValue.y))
            let streetAddress = (x & 0xf0) | (y >> 4)
            let buildingAddress = (x << 4) | (y & 0x0f)
            self.street = AddressComponent(streetAddress)
            self.building = AddressComponent(buildingAddress)
        }
    }
    var coordX: Int { Int(self.street.coordX) << 4 + self.building.coordX }
    var coordY: Int { Int(self.street.coordY) << 4 + self.building.coordY }

    // MARK: - init
    init() {
        self.street = AddressComponent()
        self.building = AddressComponent()
    }

    init(street: AddressComponent, building: AddressComponent) {
        self.street = street
        self.building = building
    }

    init(adress: UInt16) {
        self.street = AddressComponent(UInt8(truncatingIfNeeded: adress >> 8))
        self.building = AddressComponent(UInt8(adress & 0xff))
    }

    init(_ x: Int, _ y: Int) {
        let x = UInt8(truncatingIfNeeded: UInt(bitPattern: x))
        let y = UInt8(truncatingIfNeeded: UInt(bitPattern: y))
        let streetAddress = (x & 0xf0) | (y >> 4)
        let buildingAddress = (x << 4) | (y & 0x0f)
        self.street = AddressComponent(streetAddress)
        self.building = AddressComponent(buildingAddress)
    }

}

extension StreetAddress: CustomDebugStringConvertible {

    var debugDescription: String {
        return "\(self.street), (\(self.building))"
    }

}

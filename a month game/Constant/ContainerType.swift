//
//  Enum.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/20.
//

import Foundation

extension ContainerType {

    static let FIELD = ContainerType(rawValue: 0)
    static let INVENTORY = ContainerType(rawValue: 1)
    static let THIRD_HAND = ContainerType(rawValue: 2)

}

class ContainerType: RawTypeWrapper {

    typealias RawValue = Int

    let rawValue: Int

    static var count: Int { return 3 }

    required init(rawValue: Int) {
        self.rawValue = (0..<TileType.count).contains(rawValue)
            ? rawValue
            : 0
    }

}

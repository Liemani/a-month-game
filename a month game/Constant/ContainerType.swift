//
//  Enum.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/20.
//

import Foundation

extension ContainerType {

    static let FIELD = ContainerType(rawValue: 0)!
    static let INVENTORY = ContainerType(rawValue: 1)!
    static let THIRD_HAND = ContainerType(rawValue: 2)!

}

class ContainerType: RawTypeWrapper {

    override class var count: Int { return 3 }

    override init?(rawValue: Int) {
        super.init(rawValue: rawValue)
    }

}

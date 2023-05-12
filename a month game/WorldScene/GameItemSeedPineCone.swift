//
//  GameItemSeedPineCone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameItemSeedPineCone: GameItem {

    static let typeID: Int = Helper.getTypeID(from: GameItemSeedPineCone.self)

    init() {
        super.init(typeID: GameItemSeedPineCone.typeID)
    }

}

//
//  GameItemSeedPineCone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameItemSeedPineCone: GameObject {

    static let typeID: Int = Helper.getTypeID(from: GameItemSeedPineCone.self)

    required init(position: GameObjectPosition, id: Int?) {
        super.init(position: position, typeID: GameItemSeedPineCone.typeID, id: id)
    }

}

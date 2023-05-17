//
//  GameItemSeedPineCone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameObjectSeedPineCone: GameObject {

    static let typeID: Int = Helper.getTypeID(from: GameObjectSeedPineCone.self)

    required init(id: Int?, coordinate: GameObjectCoordinate) {
        super.init(id: id, coordinate: coordinate, typeID: GameObjectSeedPineCone.typeID)
    }

}

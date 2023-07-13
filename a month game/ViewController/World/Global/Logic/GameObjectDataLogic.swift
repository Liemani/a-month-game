//
//  GameObjectDataLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

class GameObjectDataLogic {
    
    /// suppose goData was in the inventory
    /// suppose invData always has empty space
    func move(_ goData: GameObjectData, to invData: InventoryData) {
        if let sourceInvData = Logics.default.invContainer.inv(id: goData.invCoord!.id)?.data {
            sourceInvData.remove(goData)
        }

        goData.set(coord: invData.emptyCoord!)

        invData.add(goData)
    }

}

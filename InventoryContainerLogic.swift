//
//  InventoryContainerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation

class InventoryContainerLogic {

    private let invContainer: InventoryContainer

    init(invContainer: InventoryContainer) {
        self.invContainer = invContainer
    }

    func `is`(equiping goType: GameObjectType) -> Bool {
        return self.invContainer.is(equiping: goType)
    }

    var emptyCoord: InventoryCoordinate? {
        return self.invContainer.emptyCoord
    }

}

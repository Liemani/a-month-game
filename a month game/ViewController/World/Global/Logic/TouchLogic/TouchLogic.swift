//
//  TouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation

class TouchLogic {

    var activatedGO: GameObject?

    let goHandler: GameObjectTouchHandler
    let fieldHandler: FieldTouchHandler
    let invTouchHandler: InventoryTouchHandler
    let craftTouchHandler: CraftTouchHandler

    init(chunkContainer: ChunkContainer, invContainer: InventoryContainer) {
        self.goHandler = GameObjectTouchHandler()
        self.fieldHandler = FieldTouchHandler(invContainer: invContainer, chunkContainer: chunkContainer)
        self.invTouchHandler = InventoryTouchHandler()
        self.craftTouchHandler = CraftTouchHandler(invContainer: invContainer)
    }

}

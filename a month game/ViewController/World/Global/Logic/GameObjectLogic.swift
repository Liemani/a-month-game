//
//  GameObjectLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation
import SpriteKit

class GameObjectLogic {

    let goInteractionHandlerManager: InteractionLogic

    let scene: WorldScene
    let character: Character
    let chunkContainer: ChunkContainer
    let invContainer: InventoryContainer
    let accessibleGOTracker: AccessibleGOTracker

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.goInteractionHandlerManager = InteractionLogic(
            ui: ui,
            invInv: invInv,
            fieldInv: fieldInv,
            invContainer: invContainer,
            chunkContainer: chunkContainer)

        self.scene = scene
        self.character = character
        self.chunkContainer = chunkContainer
        self.invContainer = invContainer
        self.accessibleGOTracker = accessibleGOTracker
    }
    
}

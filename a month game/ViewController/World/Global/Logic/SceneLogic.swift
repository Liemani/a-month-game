//
//  SceneLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class SceneLogic {

    let goInteractionHandlerManager: InteractionLogic

    let scene: WorldScene
    let character: Character
    let invContainer: InventoryContainer
    let chunkContainer: ChunkContainer
    let accessibleGOTracker: AccessibleGOTracker

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         character: Character,
         invContainer: InventoryContainer,
         chunkContainer: ChunkContainer,
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

    // MARK: logic
    func new(type goType: GameObjectType,
             variant: Int = 0,
             count: Int = 1,
             coord chunkCoord: ChunkCoordinate) {
        for _ in 0 ..< count {
            LogicContainer.default.sceneLow.new(type: goType,
                                                variant: variant,
                                                coord: chunkCoord)
        }
    }

    func move(_ go: GameObject, to invCoord: InventoryCoordinate) {
        guard !go.type.isInv
                || invCoord.id == Constant.characterInventoryID
                || ServiceContainer.default.invServ.isEmpty(id: go.id) else {
            return
        }

        LogicContainer.default.sceneLow.move(go, to: invCoord)
    }

    func move(_ go: GameObject, to chunkCoord: ChunkCoordinate) {
        // TODO: copose
//        check inventory
//        if inventory and open -> close
//        move
    }

}

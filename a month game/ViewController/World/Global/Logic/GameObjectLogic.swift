//
//  GameObjectLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation
import SpriteKit

class GameObjectLogic {

    private let interactionLogic: InteractionLogic

    init() {
        self.interactionLogic = InteractionLogic()
    }
    
    func interact(_ go: GameObject) {
        if let handler = self.interactionLogic.go[go.type] {
            handler(self.interactionLogic, go)
        }

        if go.type.isInv {
            LogicContainer.default.scene.containerInteract(go)
        }
    }

    func interactToGO(_ go: GameObject, to target: GameObject) {
        if let handler = self.interactionLogic.goToGO[target.type] {
            handler(self.interactionLogic, go, target)
        }

        if go.isExist,
           target.type.isTile,
           let targetCoord = target.chunkCoord {
            self.move(go, to: targetCoord)
        }
    }

    func new(type goType: GameObjectType, variant: Int = 0, coord chunkCoord: ChunkCoordinate) {
        let go = GameObject(type: goType, variant: variant, coord: chunkCoord)
        LogicContainer.default.chunkContainer.add(go)
    }

    func new(type goType: GameObjectType, variant: Int = 0, coord invCoord: InventoryCoordinate) {
        let go = GameObject(type: goType, variant: variant, coord: invCoord)
        LogicContainer.default.invContainer.add(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func move(_ go: GameObject, to invCoord: InventoryCoordinate) {
        self.removeFromParent(go)
        go.set(coord: invCoord)
        LogicContainer.default.invContainer.add(go)
    }

    func move(_ go: GameObject, to chunkCoord: ChunkCoordinate) {
        self.removeFromParent(go)
        go.set(coord: chunkCoord)
        LogicContainer.default.chunkContainer.add(go)
    }

    func removeFromParent(_ go: GameObject) {
        if let chunk = go.parent as? Chunk {
            chunk.remove(go)
            LogicContainer.default.accessibleGOTracker.remove(go)
        } else if let inventory = go.parent?.parent as? Inventory {
            inventory.remove(go)

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        }
    }

    func remove(_ go: GameObject) {
        self.removeFromParent(go)
        go.delete()
    }

}

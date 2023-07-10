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
            Logics.default.scene.containerInteract(go)
        }
    }

    func interactToGO(_ go: GameObject, to target: GameObject) {
        if let handler = self.interactionLogic.goToGO[target.type] {
            handler(self.interactionLogic, go, target)
        }

        if target.type.isInv {
            if go.type.isInv {
                Logics.default.scene.containerTransfer(go, to: target)
            } else {
                Logics.default.scene.gameObjectInteractContainer(go, to: target)
            }

            return
        }

        if go.isExist,
           target.type.isTile,
           let targetCoord = target.chunkCoord {
            self.move(go, to: targetCoord)

            return
        }
    }

    func new(type goType: GameObjectType,
             variant: Int = 0,
             quality: Double = 0.0,
             state: GameObjectState = [],
             coord chunkCoord: ChunkCoordinate) {
        let go = GameObject(type: goType,
                            variant: variant,
                            quality: quality,
                            state: state,
                            coord: chunkCoord)
        Logics.default.chunkContainer.add(go)
    }

    func new(type goType: GameObjectType,
             variant: Int = 0,
             quality: Double = 0.0,
             state: GameObjectState = [],
             coord invCoord: InventoryCoordinate) {
        let quality = max(quality, 0)

        let go = GameObject(type: goType,
                            variant: variant,
                            quality: quality,
                            state: state,
                            coord: invCoord)
        Logics.default.invContainer.add(go)

        FrameCycleUpdateManager.default.update(with: .craftWindow)
    }

    func move(_ go: GameObject, to invCoord: InventoryCoordinate) {
        go.addQualityBox()

        self.removeFromParent(go)
        go.set(coord: invCoord)
        Logics.default.invContainer.add(go)
    }

    func move(_ go: GameObject, to chunkCoord: ChunkCoordinate) {
        go.removeQualityBox()

        self.removeFromParent(go)
        go.set(coord: chunkCoord)
        Logics.default.chunkContainer.add(go)
    }

    func removeFromParent(_ go: GameObject) {
        if let chunk = go.parent as? Chunk {
            chunk.remove(go)
            Logics.default.accessibleGOTracker.remove(go)
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

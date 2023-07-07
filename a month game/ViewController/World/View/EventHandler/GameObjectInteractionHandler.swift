//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation
import SpriteKit

class GameObjectInteractionHandlerManager {

    let ui: SKNode

    let invInv: GameObjectInventory
    let fieldInv: GameObjectInventory

    let invContainer: InventoryContainer
    let chunkContainer: ChunkContainer

    init(
        ui: SKNode,
        invInv: GameObjectInventory,
        fieldInv: GameObjectInventory,
        invContainer: InventoryContainer,
        chunkContainer: ChunkContainer
    ) {
        self.ui = ui
        self.invInv = invInv
        self.fieldInv = fieldInv
        self.invContainer = invContainer
        self.chunkContainer = chunkContainer
    }

    let goHandler: [GameObjectType: (GameObjectInteractionHandlerManager, GameObject) -> Void] = [
        .caveCeilTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stonePickaxe) else {
                return
            }

            go.set(type: .caveHoleTile)
            LogicContainer.default.scene.new(type: .stone, variant: 0, invCoord: emptyInvCoord)
        },
        .sandTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .clayTile)
            LogicContainer.default.scene.new(type: .sand, variant: 0, invCoord: emptyInvCoord)
        },
        .clayTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .caveCeilTile)
            LogicContainer.default.scene.new(type: .clay, variant: 0, invCoord: emptyInvCoord)
        },
        .cobblestoneTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord else {
                return
            }

            go.set(type: .sandTile)
            LogicContainer.default.scene.new(type: .stone, variant: 0, invCoord: emptyInvCoord)
        },
        .dirtTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .clayTile)
            LogicContainer.default.scene.new(type: .dirt, variant: 0, invCoord: emptyInvCoord)
        },
        .treeOak: { handlerManager, go in
            if handlerManager.invContainer.is(equiping: .stoneAxe) {
                let chunkCoord = go.chunkCoord!

                LogicContainer.default.scene.new(type: .woodLog, chunkCoord: chunkCoord)
                if go.variant == 0 {
                    LogicContainer.default.scene.new(type: .woodStick,
                                                  count: 2,
                                                  chunkCoord: chunkCoord)
                }

                LogicContainer.default.scene.new(type: .treeOakSeed,
                                              count: 2,
                                              chunkCoord: chunkCoord)

                LogicContainer.default.scene.remove(go)

                return
            }

            guard go.variant == 0,
                  handlerManager.invContainer.space >= 2 else {
                return
            }

            go.set(variant: 1)
            LogicContainer.default.scene.new(type: .woodStick, variant: 0, invCoord: handlerManager.invContainer.emptyCoord!)
            LogicContainer.default.scene.new(type: .woodStick, variant: 0, invCoord: handlerManager.invContainer.emptyCoord!)
        },
        .weed: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .sickle) else {
                return
            }

            LogicContainer.default.scene.new(type: .weedLeaves, invCoord: emptyInvCoord)
            LogicContainer.default.scene.remove(go)
        },
        .leafBag: { handlerManager, go in
            if handlerManager.invInv.id == go.id
                && !handlerManager.invInv.isHidden {
                handlerManager.invInv.isHidden = true

                FrameCycleUpdateManager.default.update(with: .craftWindow)

                return
            }

            if handlerManager.fieldInv.id == go.id
                && !handlerManager.fieldInv.isHidden {
                handlerManager.fieldInv.isHidden = true

                FrameCycleUpdateManager.default.update(with: .craftWindow)

                return
            }

            if go.isOnField {
                handlerManager.fieldInv.update(go)
                handlerManager.fieldInv.isHidden = false
                handlerManager.fieldInv.position = go.positionInWorld
                + CGPoint(x: 0, y: Constant.defaultWidth + Constant.invCellSpacing)
            } else {
                handlerManager.invInv.update(go)
                handlerManager.invInv.isHidden = false
                handlerManager.invInv.position =
                    go.convert(CGPoint(), to: handlerManager.ui)
                    + CGPoint(x: 0,
                              y: Constant.defaultWidth + Constant.invCellSpacing)
            }

            FrameCycleUpdateManager.default.update(with: .craftWindow)
        },
    ]

    let goToGOHandler: [GameObjectType: (GameObjectInteractionHandlerManager, GameObject, GameObject) -> Void] = [
        .treeOakSeed: { handlerManager, go, targetGO in
            let oakSeed = targetGO

            guard go.type == .dirt,
                    let seedChunkCoord = oakSeed.chunkCoord else {
                return
            }

            let gos = handlerManager.chunkContainer.items(at: seedChunkCoord)!
            guard let clayTile = gos.first(where: { $0.type == .clayTile }) else {
                return
            }

            clayTile.set(type: .dirtTile)
            oakSeed.set(type: .treeOak)
            LogicContainer.default.scene.remove(go)
        },
        .leafBag: { handlerManager, go, targetGO in
            var index: Int = 0

            if let inv = handlerManager.invContainer.inv(id: targetGO.id) {
                if let emptyIndex = inv.emptyCoord {
                    index = emptyIndex
                } else {
                    return
                }
            } else {
                let emptyIndex = WorldServiceContainer.default.invServ.emptyIndex(id: targetGO.id)

                if index < targetGO.type.invSpace {
                    index = emptyIndex
                } else {
                    return
                }
            }

            let invCoord = InventoryCoordinate(targetGO.id, index)
            LogicContainer.default.scene.move(go, to: invCoord)
        }
    ]
}

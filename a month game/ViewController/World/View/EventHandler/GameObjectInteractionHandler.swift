//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation
import SpriteKit

class InteractionLogic {

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

    let go: [GameObjectType: (InteractionLogic, GameObject) -> Void] = [
        .caveCeilTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stonePickaxe) else {
                return
            }

            go.set(type: .caveHoleTile)
            LogicContainer.default.sceneLow.new(type: .stone, coord: emptyInvCoord)
        },
        .sandTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .clayTile)
            LogicContainer.default.sceneLow.new(type: .sand, coord: emptyInvCoord)
        },
        .clayTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .caveCeilTile)
            LogicContainer.default.sceneLow.new(type: .clay, coord: emptyInvCoord)
        },
        .cobblestoneTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord else {
                return
            }

            go.set(type: .sandTile)
            LogicContainer.default.sceneLow.new(type: .stone, coord: emptyInvCoord)
        },
        .dirtTile: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .clayTile)
            LogicContainer.default.sceneLow.new(type: .dirt, coord: emptyInvCoord)
        },
        .treeOak: { handlerManager, go in
            if handlerManager.invContainer.is(equiping: .stoneAxe) {
                let chunkCoord = go.chunkCoord!

                LogicContainer.default.sceneLow.new(type: .woodLog, coord: chunkCoord)
                if go.variant == 0 {
                    LogicContainer.default.scene.new(type: .woodStick,
                                                  count: 2,
                                                  coord: chunkCoord)
                }

                LogicContainer.default.scene.new(type: .treeOakSeed,
                                              count: 2,
                                              coord: chunkCoord)

                LogicContainer.default.sceneLow.remove(go)

                return
            }

            guard go.variant == 0,
                  handlerManager.invContainer.space >= 2 else {
                return
            }

            go.set(variant: 1)
            LogicContainer.default.sceneLow.new(type: .woodStick, coord: handlerManager.invContainer.emptyCoord!)
            LogicContainer.default.sceneLow.new(type: .woodStick, coord: handlerManager.invContainer.emptyCoord!)
        },
        .weed: { handlerManager, go in
            guard let emptyInvCoord = handlerManager.invContainer.emptyCoord,
                  handlerManager.invContainer.is(equiping: .sickle) else {
                return
            }

            LogicContainer.default.sceneLow.new(type: .weedLeaves, coord: emptyInvCoord)
            LogicContainer.default.sceneLow.remove(go)
        },
        .leafBag: { handlerManager, go in
            if handlerManager.invInv.id == go.id
                && !handlerManager.invInv.isHidden {
                LogicContainer.default.sceneLow.closeInvInv()

                return
            }

            if handlerManager.fieldInv.id == go.id
                && !handlerManager.fieldInv.isHidden {
                LogicContainer.default.sceneLow.closeFieldInv()

                return
            }

            if let invCoord = go.invCoord,
                  invCoord.id != Constant.characterInventoryID {
                return
            }

            if go.isOnField {
                LogicContainer.default.sceneLow.openFieldInv(of: go)
            } else {
                LogicContainer.default.sceneLow.openInvInv(of: go)
            }
        },
    ]

    let goToGO: [GameObjectType: (InteractionLogic, GameObject, GameObject) -> Void] = [
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
            LogicContainer.default.sceneLow.remove(go)
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
                let emptyIndex = ServiceContainer.default.invServ.emptyIndex(id: targetGO.id)

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

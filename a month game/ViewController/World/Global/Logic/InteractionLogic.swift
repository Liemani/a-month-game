//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation
import SpriteKit

class InteractionLogic {

    let go: [GameObjectType: (InteractionLogic, GameObject) -> Void] = [
        .caveCeilTile: { handlerManager, go in
            guard LogicContainer.default.invContainer.is(equiping: .stonePickaxe),
                  let emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .caveHoleTile)
            LogicContainer.default.go.new(type: .stone, coord: emptyInvCoord)
        },
        .sandTile: { handlerManager, go in
            guard LogicContainer.default.invContainer.is(equiping: .stoneShovel),
                  let emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .clayTile)
            LogicContainer.default.go.new(type: .sand, coord: emptyInvCoord)
        },
        .clayTile: { handlerManager, go in
            guard LogicContainer.default.invContainer.is(equiping: .stoneShovel),
                  let emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .caveCeilTile)
            LogicContainer.default.go.new(type: .clay, coord: emptyInvCoord)
        },
        .cobblestoneTile: { handlerManager, go in
            guard let  emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .sandTile)
            LogicContainer.default.go.new(type: .stone, coord: emptyInvCoord)
        },
        .dirtTile: { handlerManager, go in
            guard LogicContainer.default.invContainer.is(equiping: .stoneShovel),
                  let emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .clayTile)
            LogicContainer.default.go.new(type: .dirt, coord: emptyInvCoord)
        },
        .weed: { handlerManager, go in
            guard LogicContainer.default.invContainer.is(equiping: .sickle),
                  let emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            LogicContainer.default.go.remove(go)
            LogicContainer.default.go.new(type: .weedLeaves, coord: emptyInvCoord)
        },
        .vine: { handlerManager, go in
            guard LogicContainer.default.invContainer.is(equiping: .sickle),
                  let emptyInvCoord = LogicContainer.default.invContainer.emptyCoord else {
                return
            }

            LogicContainer.default.go.remove(go)
            LogicContainer.default.go.new(type: .vineStem, coord: emptyInvCoord)
        },
        .treeOak: { handlerManager, go in
            if LogicContainer.default.invContainer.is(equiping: .stoneAxe) {
                let chunkCoord = go.chunkCoord!

                LogicContainer.default.go.new(type: .woodLog, coord: chunkCoord)
                if go.variant == 0 {
                    LogicContainer.default.scene.new(type: .woodStick,
                                                  count: 2,
                                                  coord: chunkCoord)
                }

                LogicContainer.default.scene.new(type: .treeOakSeed,
                                              count: 2,
                                              coord: chunkCoord)

                LogicContainer.default.go.remove(go)

                return
            }

            guard go.variant == 0,
                  LogicContainer.default.invContainer.space >= 2 else {
                return
            }

            go.set(variant: 1)

            var emptyCoord = LogicContainer.default.invContainer.emptyCoord!
            LogicContainer.default.go.new(type: .woodStick, coord: emptyCoord)

            emptyCoord = LogicContainer.default.invContainer.emptyCoord!
            LogicContainer.default.go.new(type: .woodStick, coord: emptyCoord)
        },
    ]

    let goToGO: [GameObjectType: (InteractionLogic, GameObject, GameObject) -> Void] = [
        .treeOakSeed: { handlerManager, go, target in
            let oakSeed = target

            guard go.type == .dirt,
                    let seedChunkCoord = oakSeed.chunkCoord else {
                return
            }

            let gos = LogicContainer.default.chunkContainer.items(at: seedChunkCoord)!
            guard let clayTile = gos.first(where: { $0.type == .clayTile }) else {
                return
            }

            clayTile.set(type: .dirtTile)
            oakSeed.set(type: .treeOak)
            LogicContainer.default.go.remove(go)
        },
        .caveCeilTile: { handlerManager, go, target in
            guard go.type == .clay else { return }

            LogicContainer.default.go.remove(go)
            target.set(type: .clayTile)
        },
        .clayTile: { handlerManager, go, target in
            if go.type == .sand {
                LogicContainer.default.go.remove(go)
                target.set(type: .sandTile)

                return
            }

            if go.type == .dirt {
                LogicContainer.default.go.remove(go)
                target.set(type: .dirtTile)

                return
            }
        },
        .sandTile: { handlerManager, go, target in
            guard go.type == .stone else { return }

            LogicContainer.default.go.remove(go)
            target.set(type: .cobblestoneTile)
        },
        .caveHoleTile: { handlerManager, go, target in
            guard go.type == .stone else { return }

            LogicContainer.default.go.remove(go)
            target.set(type: .caveCeilTile)
        },
        .waterTile: { handlerManager, go, target in
            LogicContainer.default.go.remove(go)
        },
    ]
}

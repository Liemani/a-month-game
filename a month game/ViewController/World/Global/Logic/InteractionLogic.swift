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
        .dirtTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(with: .shovel, to: .dirtTile)

            go.set(type: .clayTile)
            Logics.default.scene.new(result: result,
                                     type: .dirt,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)
        },
        .clayTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(with: .shovel, to: .clayTile)

            go.set(type: .caveCeilTile)
            Logics.default.scene.new(result: result,
                                     type: .clay,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)
        },
        .caveCeilTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .pickaxe),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(with: .pickaxe, to: .caveCeilTile)

            go.set(type: .caveHoleTile)
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)
        },
        .cobblestoneTile: { handleManager, go in
            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(.cobblestoneTile)

            go.set(type: .sandTile)
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     coord: emptyInvCoord)
        },
        .sandTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(with: .shovel, to: .sandTile)

            go.set(type: .clayTile)
            Logics.default.scene.new(result: result,
                                     type: .sand,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)
        },
        .weed: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(with: .sickle, to: .weed)

            Logics.default.go.remove(go)
            Logics.default.scene.new(result: result,
                                     type: .weedLeaves,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)
        },
        .vine: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            let result = Logics.default.mastery.interact(with: .sickle, to: .vine)

            Logics.default.go.remove(go)
            Logics.default.scene.new(result: result,
                                     type: .vineStem,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)
        },
        .treeOak: { handlerManager, go in
            if let goEquiping = Logics.default.invContainer.go(equiping: .axe) {
                let newQuality = (go.quality + goEquiping.quality) / 2.0
                let chunkCoord = go.chunkCoord!

                let result = Logics.default.mastery.interact(with: .axe, to: .treeOak)

                Logics.default.go.remove(go)

                Logics.default.scene.new(result: result,
                                         type: .woodLog,
                                         quality: newQuality,
                                         coord: chunkCoord)

                if go.variant == 0 {
                    Logics.default.scene.new(result: result,
                                             type: .woodStick,
                                             quality: newQuality,
                                             coord: chunkCoord,
                                             count: 2)
                }

                Logics.default.scene.new(result: result,
                                         type: .treeOakSeed,
                                         quality: newQuality,
                                         coord: chunkCoord,
                                         count: 2)

                return
            }

            guard go.variant == 0,
                  Logics.default.invContainer.space >= 2 else {
                return
            }

            let result = Logics.default.mastery.interact(.treeOak)

            go.set(variant: 1)

            for _ in 0 ..< 2 {
                let emptyInvCoord = Logics.default.invContainer.emptyCoord!

                Logics.default.scene.new(result: result,
                                         type: .woodStick,
                                         quality: go.quality / 2.0,
                                         coord: emptyInvCoord)
            }
        },
    ]

    let goToGO: [GameObjectType: (InteractionLogic, GameObject, GameObject) -> Void] = [
        .waterTile: { handlerManager, go, target in
            // TODO: if go is container, remove only the item inside

            Logics.default.go.remove(go)
        },
        .clayTile: { handlerManager, go, target in

            if go.type == .sand {
                let result = Logics.default.mastery.interact(with: .sand, to: .clayTile)

                Logics.default.go.remove(go)
                Logics.default.scene.set(result: result, go: target, type: .sandTile)

                return
            }

            if go.type == .dirt {
                let result = Logics.default.mastery.interact(with: .dirt, to: .clayTile)

                Logics.default.go.remove(go)
                Logics.default.scene.set(result: result, go: target, type: .dirtTile)

                return
            }
        },
        .caveCeilTile: { handlerManager, go, target in
            guard go.type == .clay else { return }

            let result = Logics.default.mastery.interact(with: .clay, to: .caveCeilTile)

            Logics.default.go.remove(go)
            Logics.default.scene.set(result: result, go: target, type: .clayTile)
        },
        .caveHoleTile: { handlerManager, go, target in
            guard go.type == .stone else { return }

            let result = Logics.default.mastery.interact(with: .stone, to: .caveHoleTile)

            Logics.default.go.remove(go)
            Logics.default.scene.set(result: result, go: target, type: .caveCeilTile)
        },
        .sandTile: { handlerManager, go, target in
            guard go.type == .stone else { return }

            let result = Logics.default.mastery.interact(with: .stone, to: .sandTile)

            Logics.default.go.remove(go)
            Logics.default.scene.set(result: result, go: target, type: .cobblestoneTile)
        },
        .treeOakSeed: { handlerManager, go, target in
            let oakSeed = target

            guard go.type == .dirt,
                    let seedChunkCoord = oakSeed.chunkCoord else {
                return
            }

            let gosInTile = Logics.default.chunkContainer.items(at: seedChunkCoord)!

            guard let clayTile = gosInTile.first(where: { $0.type == .clayTile }) else {
                return
            }

            let result = Logics.default.mastery.interact(with: .stone, to: .sandTile)

            Logics.default.go.remove(go)

            Logics.default.scene.set(result: result, go: clayTile, type: .dirtTile)
            Logics.default.scene.set(result: result, go: oakSeed, type: .treeOak)
            let newQuality = (oakSeed.quality + go.quality) / 2.0
            Logics.default.scene.set(result: result, go: oakSeed, quality: newQuality)
        },
    ]
}

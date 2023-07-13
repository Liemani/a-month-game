//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation
import SpriteKit

class InteractionLogic {

    let go: [GameObjectType: (InteractionLogic, GameObject) -> Bool] = [
        .dirtTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .shovel, to: .dirtTile)

            go.set(type: .clayTile)
            Logics.default.scene.new(result: result,
                                     type: .dirt,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .clayTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .shovel, to: .clayTile)

            go.set(type: .caveCeilTile)
            Logics.default.scene.new(result: result,
                                     type: .clay,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .caveCeilTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .pickaxe),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .pickaxe, to: .caveCeilTile)

            go.set(type: .caveHoleTile)
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .cobblestoneTile: { handleManager, go in
            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(.cobblestoneTile)

            go.set(type: .sandTile)
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     coord: emptyInvCoord)

            return true
        },
        .sandTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .shovel, to: .sandTile)

            go.set(type: .clayTile)
            Logics.default.scene.new(result: result,
                                     type: .sand,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .weed: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .sickle, to: .weed)

            Logics.default.go.delete(go)
            Logics.default.scene.new(result: result,
                                     type: .weedLeaves,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .vine: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .sickle, to: .vine)

            Logics.default.go.delete(go)
            Logics.default.scene.new(result: result,
                                     type: .vineStem,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .treeOak: { handlerManager, go in
            if let goEquiping = Logics.default.invContainer.go(equiping: .axe) {
                let newQuality = (go.quality + goEquiping.quality) / 2.0
                let chunkCoord = go.chunkCoord!

                let result = Logics.default.mastery.interact(with: .axe, to: .treeOak)

                Logics.default.go.delete(go)

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

                return true
            }

            guard go.variant == 0,
                  Logics.default.invContainer.space >= 2 else {
                return false
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

            return true
        },
    ]

    let goToGO: [GameObjectType: (InteractionLogic, GameObject, GameObject) -> Bool] = [
        .waterTile: { handlerManager, go, target in
            if go.type.isContainer {
                if !Logics.default.invContainer.isEmpty(go.id) {
                    Logics.default.invContainer.deleteAll(go.id)

                    return true
                }
            }

            Logics.default.scene.delete(go)

            return true
        },
        .clayTile: { handlerManager, go, target in
            if go.type == .sand {
                let result = Logics.default.mastery.interact(with: .sand, to: .clayTile)

                Logics.default.go.delete(go)
                Logics.default.scene.set(result: result, go: target, type: .sandTile)

                return true
            }

            if go.type == .dirt {
                let result = Logics.default.mastery.interact(with: .dirt, to: .clayTile)

                Logics.default.go.delete(go)
                Logics.default.scene.set(result: result, go: target, type: .dirtTile)

                return true
            }

            return false
        },
        .caveCeilTile: { handlerManager, go, target in
            guard go.type == .clay else { return false }

            let result = Logics.default.mastery.interact(with: .clay, to: .caveCeilTile)

            Logics.default.go.delete(go)
            Logics.default.scene.set(result: result, go: target, type: .clayTile)

            return true
        },
        .caveHoleTile: { handlerManager, go, target in
            guard go.type == .stone else { return false }

            let result = Logics.default.mastery.interact(with: .stone, to: .caveHoleTile)

            Logics.default.go.delete(go)
            Logics.default.scene.set(result: result, go: target, type: .caveCeilTile)

            return true
        },
        .sandTile: { handlerManager, go, target in
            guard go.type == .stone else { return false }

            let result = Logics.default.mastery.interact(with: .stone, to: .sandTile)

            Logics.default.go.delete(go)
            Logics.default.scene.set(result: result, go: target, type: .cobblestoneTile)

            return true
        },
        .treeOakSeed: { handlerManager, go, target in
            let oakSeed = target

            guard go.type == .dirt,
                    let seedChunkCoord = oakSeed.chunkCoord else {
                return false
            }

            let gosInTile = Logics.default.chunkContainer.items(at: seedChunkCoord)!

            guard let clayTile = gosInTile.first(where: { $0.type == .clayTile }) else {
                return false
            }

            let result = Logics.default.mastery.interact(with: .stone, to: .sandTile)

            Logics.default.go.delete(go)

            Logics.default.scene.set(result: result, go: clayTile, type: .dirtTile)
            Logics.default.scene.set(result: result, go: oakSeed, type: .treeOak)
            let newQuality = (oakSeed.quality + go.quality) / 2.0
            Logics.default.scene.set(result: result, go: oakSeed, quality: newQuality)

            return true
        },
    ]
}

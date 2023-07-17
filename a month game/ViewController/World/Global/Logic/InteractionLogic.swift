//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation
import SpriteKit

class InteractionLogic {

    let go: [GameObjectType: (GameObject) -> Bool] = [
        .dirtTile: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.set(type: .clayTile)
            Logics.default.scene.new(result: result,
                                     type: .dirt,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .clayTile: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.set(type: .caveCeilTile)
            Logics.default.scene.new(result: result,
                                     type: .clay,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .caveCeilTile: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .pickaxe),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.set(type: .caveHoleTile)
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .cobblestoneTile: { go in
            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(go.type)

            go.set(type: .sandTile)
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     coord: emptyInvCoord)

            return true
        },
        .sandTile: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.set(type: .clayTile)
            Logics.default.scene.new(result: result,
                                     type: .sand,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .weed: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle) else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete()
            Logics.default.scene.new(result: result,
                                     type: .weedLeaves,
                                     quality: goEquiping.quality,
                                     coord: go.chunkCoord!)

            return true
        },
        .vine: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete()
            Logics.default.scene.new(result: result,
                                     type: .vineStem,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .treeOak: { go in
            if let goEquiping = Logics.default.invContainer.go(equiping: .axe) {

                goEquiping.emphasizeUsing()

                let newQuality = (go.quality + goEquiping.quality) / 2.0
                let chunkCoord = go.chunkCoord!

                let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                             to: go.type)

                go.delete()

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

            let result = Logics.default.mastery.interact(go.type)

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
        .woodLog: { go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .saw),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete()

            let newGOQuality = (go.quality + goEquiping.quality) / 2.0

            Logics.default.scene.new(result: result,
                                     type: .woodBoard,
                                     quality: newGOQuality,
                                     coord: go.chunkCoord!,
                                     count: 2)

            return true
        },
    ]

    let goToGO: [GameObjectType: (GameObject, GameObject) -> Bool] = [
        .waterTile: { go, target in
            if go.type.isContainer {
                if !Logics.default.invContainer.isEmpty(go.id) {
                    Logics.default.invContainer.deleteAll(go.id)

                    return true
                }
            }

            go.delete()

            return true
        },
        .clayTile: { go, target in
            if go.type == .sand {
                let result = Logics.default.mastery.interact(with: target.type,
                                                             to: go.type)

                go.delete()
                Logics.default.scene.set(result: result, go: target, type: .sandTile)

                return true
            }

            if go.type == .dirt {
                let result = Logics.default.mastery.interact(with: target.type,
                                                             to: go.type)

                go.delete()
                Logics.default.scene.set(result: result, go: target, type: .dirtTile)

                return true
            }

            return false
        },
        .caveCeilTile: { go, target in
            guard go.type == .clay else { return false }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()
            Logics.default.scene.set(result: result, go: target, type: .clayTile)

            return true
        },
        .caveHoleTile: { go, target in
            guard go.type == .stone else { return false }

            let result = Logics.default.mastery.interact(with: .stone, to: .caveHoleTile)

            go.delete()
            Logics.default.scene.set(result: result, go: target, type: .caveCeilTile)

            return true
        },
        .sandTile: { go, target in
            guard go.type == .stone else { return false }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()
            Logics.default.scene.set(result: result, go: target, type: .cobblestoneTile)

            return true
        },
        .treeOakSeed: { go, target in
            let oakSeed = target

            guard go.type == .dirt,
                    let seedChunkCoord = oakSeed.chunkCoord else {
                return false
            }

            let gosInTile = Logics.default.chunkContainer.items(at: seedChunkCoord)

            guard let clayTile = gosInTile.first(where: { $0.type == .clayTile }) else {
                return false
            }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()

            Logics.default.scene.set(result: result, go: clayTile, type: .dirtTile)
            Logics.default.scene.set(result: result, go: oakSeed, type: .treeOak)
            let newQuality = (oakSeed.quality + go.quality) / 2.0
            Logics.default.scene.set(result: result, go: oakSeed, quality: newQuality)

            return true
        },
    ]
}

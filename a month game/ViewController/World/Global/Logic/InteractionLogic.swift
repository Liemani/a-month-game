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

            go.set(type: .clayTile)
            Logics.default.go.new(type: .dirt,
                                  quality: goEquiping.quality,
                                  coord: emptyInvCoord)
        },
        .clayTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }


            go.set(type: .caveCeilTile)
            Logics.default.go.new(type: .clay,
                                  quality: goEquiping.quality,
                                  coord: emptyInvCoord)
        },
        .caveCeilTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .pickaxe),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .caveHoleTile)
            Logics.default.go.new(type: .stone,
                                  quality: goEquiping.quality,
                                  coord: emptyInvCoord)
        },
        .cobblestoneTile: { handleManager, go in
            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .sandTile)
            Logics.default.go.new(type: .stone,
                                  coord: emptyInvCoord)
        },
        .sandTile: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .shovel),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            go.set(type: .clayTile)
            Logics.default.go.new(type: .sand,
                                  quality: goEquiping.quality,
                                  coord: emptyInvCoord)
        },
        .weed: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            Logics.default.go.remove(go)
            Logics.default.go.new(type: .weedLeaves,
                                  quality: goEquiping.quality,
                                  coord: emptyInvCoord)
        },
        .vine: { handlerManager, go in
            guard let goEquiping = Logics.default.invContainer.go(equiping: .sickle),
                  let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return
            }

            Logics.default.go.remove(go)
            Logics.default.go.new(type: .vineStem,
                                  quality: goEquiping.quality,
                                  coord: emptyInvCoord)
        },
        .treeOak: { handlerManager, go in
            if let goEquiping = Logics.default.invContainer.go(equiping: .axe) {
                let newQuality = (go.quality + goEquiping.quality) / 2.0
                let chunkCoord = go.chunkCoord!

                Logics.default.go.remove(go)

                Logics.default.go.new(type: .woodLog,
                                      quality: newQuality,
                                      coord: chunkCoord)

                if go.variant == 0 {
                    Logics.default.scene.new(type: .woodStick,
                                             quality: newQuality,
                                             coord: chunkCoord,
                                             count: 2)
                }

                Logics.default.scene.new(type: .treeOakSeed,
                                         quality: newQuality,
                                         coord: chunkCoord,
                                         count: 2)

                return
            }

            guard go.variant == 0,
                  Logics.default.invContainer.space >= 2 else {
                return
            }

            go.set(variant: 1)

            for _ in 0 ..< 2 {
                let emptyInvCoord = Logics.default.invContainer.emptyCoord!

                Logics.default.go.new(type: .woodStick,
                                      quality: go.quality / 2.0,
                                      coord: emptyInvCoord)
            }
        },
    ]

    let goToGO: [GameObjectType: (InteractionLogic, GameObject, GameObject) -> Void] = [
        .waterTile: { handlerManager, go, target in
            Logics.default.go.remove(go)
        },
        .clayTile: { handlerManager, go, target in
            if go.type == .sand {
                Logics.default.go.remove(go)
                target.set(type: .sandTile)

                return
            }

            if go.type == .dirt {
                Logics.default.go.remove(go)
                target.set(type: .dirtTile)

                return
            }
        },
        .caveCeilTile: { handlerManager, go, target in
            guard go.type == .clay else { return }

            Logics.default.go.remove(go)
            target.set(type: .clayTile)
        },
        .caveHoleTile: { handlerManager, go, target in
            guard go.type == .stone else { return }

            Logics.default.go.remove(go)
            target.set(type: .caveCeilTile)
        },
        .sandTile: { handlerManager, go, target in
            guard go.type == .stone else { return }

            Logics.default.go.remove(go)
            target.set(type: .cobblestoneTile)
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

            Logics.default.go.remove(go)
            clayTile.set(type: .dirtTile)
            oakSeed.set(type: .treeOak)
            let newQuality = (oakSeed.quality + go.quality) / 2.0
            oakSeed.set(quality: newQuality)
        },
    ]
}

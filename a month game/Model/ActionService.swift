//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation
import SpriteKit

class ActionService {

    func update() {
        for chunk in Services.default.chunkContainer.target.chunks {
            let scheduler = chunk.scheduler

            let cDate = Date()
            var timeEventCount = 0

            while timeEventCount < Constant.timeEventLimit {
                guard let go = scheduler.orderedSet.firstObject as! GameObject? else {
                    break
                }

                guard go.timeEventDate! <= cDate else {
                    break
                }

                var index = 0

                while index < scheduler.orderedSet.count {
                    let go = scheduler.orderedSet[index] as! GameObject
                    if go.timeEventDate! <= cDate {
                        self.runTimeEventAction(go)

                        if !go.isDeleted
                            && go.timeEventDate != nil {
                            index += 1
                        }
                    } else {
                        break
                    }
                }

                scheduler.sort()

                timeEventCount += 1
            }

            for go in scheduler.orderedSet {
                let go = go as! GameObject

                if go.timeEventDate! <= cDate {
                    go.dateLastChanged = cDate
                } else {
                    break
                }
            }

            scheduler.sort()
        }
    }

    func runTimeEventAction(_ go: GameObject) {
        let pTimeEventDate = go.timeEventDate!

        if let action = Services.default.action.time[go.type] {
            _ = action(go)
            if go.timeEventDate == nil,
               let chunk = go.chunk {
                chunk.scheduler.remove(go)
            }
        } else {
            go.delete()
        }

        go.dateLastChanged = pTimeEventDate
    }

    let interact: [GameObjectType: (GameObject) -> Bool] = [
        .dirtFloor: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .shovel) else {
                return false
            }

            goEquiping.emphasizeUsing()

            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return true
            }

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.type = .clayFloor
            Logics.default.scene.new(result: result,
                                     type: .dirt,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .clayFloor: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .shovel) else {
                return false
            }

            goEquiping.emphasizeUsing()

            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return true
            }

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.type = .caveCeilFloor
            Logics.default.scene.new(result: result,
                                     type: .clay,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .caveCeilFloor: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .pickaxe) else {
                return false
            }

            goEquiping.emphasizeUsing()

            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return true
            }

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.type = .caveHoleFloor
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .cobblestoneFloor: { go in
            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return false
            }

            let result = Logics.default.mastery.interact(go.type)

            go.type = .sandFloor
            Logics.default.scene.new(result: result,
                                     type: .stone,
                                     coord: emptyInvCoord)

            return true
        },
        .sandFloor: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .shovel) else {
                return false
            }

            goEquiping.emphasizeUsing()

            guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                return true
            }

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.type = .clayFloor
            Logics.default.scene.new(result: result,
                                     type: .sand,
                                     quality: goEquiping.quality,
                                     coord: emptyInvCoord)

            return true
        },
        .weed: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: [.sickle, .shovel]) else {
                return false
            }

            goEquiping.emphasizeUsing()

            switch goEquiping.type {
            case .sickle:
                let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                             to: go.type)

                go.delete()
                Logics.default.scene.new(result: result,
                                         type: .weedLeaves,
                                         quality: goEquiping.quality,
                                         coord: go.chunkCoord!)
                if arc4random_uniform(10) == 0 {
                    Logics.default.scene.new(result: result,
                                             type: .plantBarleySeed,
                                             quality: goEquiping.quality,
                                             coord: go.chunkCoord!)
                }
            case .shovel:
                guard let emptyInvCoord = Logics.default.invContainer.emptyCoord else {
                    return true
                }

                let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                             to: go.type)

                if result == .fail {
                    go.delete()
                    return true
                }

                go.setQuality(goEquiping.quality, by: result)
                go.move(to: emptyInvCoord)
            default:
                fatalError("It's impossible")
            }

            return true
        },
        .vine: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .sickle),
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
        .plantBarleySapling: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .sickle) else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete(result: result)

            return true
        },
        .plantBarley: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .sickle) else {
                return false
            }

            goEquiping.emphasizeUsing()

            let newQuality = (go.quality + goEquiping.quality) / 2.0
            let chunkCoord = go.chunkCoord!

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete()

            Logics.default.scene.new(result: result,
                                     type: .plantBarleySeed,
                                     quality: newQuality,
                                     coord: chunkCoord,
                                     count: 2)

            return true
        },
        .treeOakSapling: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .axe) else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete(result: result)

            return true
        },
        .treeOak: { go in
            if let goEquiping = Logics.default.invContainer.target.go(equiping: .axe) {

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

            go.variant = 1

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
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .saw),
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
        .woodWall: { go in
            guard let goEquiping = Logics.default.invContainer.target.go(equiping: .axe) else {
                return false
            }

            goEquiping.emphasizeUsing()

            let result = Logics.default.mastery.interact(with: goEquiping.type,
                                                         to: go.type)

            go.delete(result: result)

            return true
        }
    ]

    let interactGOToGO: [GameObjectType: (GameObject, GameObject) -> Bool] = [
        .waterFloor: { go, target in
            if go.type.isContainer {
                if !Logics.default.invContainer.isEmpty(go.id) {
                    Logics.default.invContainer.deleteAll(go.id)

                    return true
                }
            }

            go.delete()

            return true
        },
        .clayFloor: { go, target in
            if go.type == .sand {
                let result = Logics.default.mastery.interact(with: target.type,
                                                             to: go.type)

                go.delete()

                if result == .fail {
                    return true
                }

                target.type = .sandFloor

                return true
            }

            if go.type == .dirt {
                let result = Logics.default.mastery.interact(with: target.type,
                                                             to: go.type)

                go.delete()

                if result == .fail {
                    return true
                }

                target.type = .dirtFloor

                return true
            }

            return false
        },
        .caveCeilFloor: { go, target in
            guard go.type == .clay else { return false }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()

            if result == .fail {
                return true
            }

            target.type = .clayFloor

            return true
        },
        .caveHoleFloor: { go, target in
            guard go.type == .stone else { return false }

            let result = Logics.default.mastery.interact(with: .stone, to: .caveHoleFloor)

            go.delete()

            if result == .fail {
                return true
            }

            target.type = .caveCeilFloor

            return true
        },
        .sandFloor: { go, target in
            guard go.type == .stone else { return false }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()

            if result == .fail {
                return true
            }

            target.type = .cobblestoneFloor

            return true
        },
        .plantBarleySeed: { go, target in
            guard go.type == .dirt,
                    let seedChunkCoord = target.chunkCoord else {
                return false
            }

            let gosInFloor = Services.default.chunkContainer.items(at: seedChunkCoord)!

            guard let clayFloor = gosInFloor.first(where: { $0.type == .clayFloor }) else {
                return false
            }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()

            if result == .fail {
                target.delete()

                return true
            }

            clayFloor.type = .dirtFloor
            target.type = .plantBarleySapling
            target.quality = (target.quality + go.quality) / 2.0

            return true
        },
        .treeOakSeed: { go, target in
            guard go.type == .dirt,
                    let seedChunkCoord = target.chunkCoord else {
                return false
            }

            let gosInFloor = Services.default.chunkContainer.items(at: seedChunkCoord)!

            guard let clayFloor = gosInFloor.first(where: { $0.type == .clayFloor }) else {
                return false
            }

            let result = Logics.default.mastery.interact(with: target.type,
                                                         to: go.type)

            go.delete()

            if result == .fail {
                target.delete()

                return true
            }

            clayFloor.type = .dirtFloor
            target.type = .treeOakSapling
            target.quality = (target.quality + go.quality) / 2.0

            return true
        },
    ]

    let time: [GameObjectType: (GameObject) -> Bool] = [
        .weed: { go in
            let weedCoordInWorld = go.chunkCoord!.coord
            let adjacentDirection = Direction9.random.coord
            let adjacentFloorCoordInWorld = weedCoordInWorld + adjacentDirection

            let adjacentFloorCoord = Services.default.chunkContainer.coord(adjacentFloorCoordInWorld)
            let adjacentFloorChunkCoord = ChunkCoordinate(adjacentFloorCoordInWorld)

            guard Services.default.chunkContainer.target.isValid(adjacentFloorCoord) else {
                return true
            }

            var floor: GameObject? = nil

            let gosOnTile = Services.default.chunkContainer.target.items(at: adjacentFloorCoord)

            if let gosOnTile = gosOnTile {
                for go in gosOnTile {
                    if go.type.isFloor {
                        floor = go
                        break
                    }
                }
            }

            if let floor = floor {
                switch floor.type {
                case .dirtFloor:
                    floor.delete()
                case .clayFloor:
                    floor.type = .dirtFloor
                case .caveCeilFloor:
                    floor.type = .clayFloor
                case .caveHoleFloor:
                    floor.type = .caveCeilFloor
                default:
                    break
                }
            } else {
                if gosOnTile == nil {
                    _ = GameObject.new(type: .weed,
                                       coord: adjacentFloorChunkCoord,
                                       date: go.timeEventDate!)
                }
            }

            return true
        },
        .plantBarleySapling: { go in
            go.type = .plantBarley
            return true
        },
        .treeOakSapling: { go in
            go.type = .treeOak
            return true
        },
    ]

}

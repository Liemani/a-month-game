//
//  SimulatorLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/17.
//

import Foundation

class SimulatorLogic {

    func update() {
        for chunk in Logics.default.chunkContainer.chunkContainer.chunks {
            let scheduler = chunk.scheduler

            let cDate = Date()

            for index in 0 ..< scheduler.orderedSet.count {
                let go = scheduler.orderedSet[index] as! GameObject
                if go.scheduledDate <= cDate {
                    self.action(go)
                } else {
                    break
                }
            }

            scheduler.sort()
        }
    }

    func action(_ go: GameObject) {
        switch go.type {
        case .weed:
            self.actionWeed(go)
        default:
            break
        }

        go.dateLastChanged = go.scheduledDate
    }

    func actionWeed(_ weed: GameObject) {
        let weedChunkCoord = weed.chunkCoord!
        let randomDirection = Direction8.random.coord
        let randomTileChunkCoord = weedChunkCoord + randomDirection

        guard Logics.default.chunkContainer.isValid(randomTileChunkCoord) else {
            return
        }

        let gosOnTile = Logics.default.chunkContainer.items(at: randomTileChunkCoord)

        var tile: GameObject? = nil

        for go in gosOnTile {
            if go.type.isTile {
                tile = go
                break
            }
        }

        if let tile = tile {
            switch tile.type {
            case .dirtTile:
                tile.delete()
            case .clayTile:
                tile.set(type: .dirtTile)
            case .caveCeilTile:
                tile.set(type: .clayTile)
            case .caveHoleTile:
                tile.set(type: .caveCeilTile)
            default:
                break
            }
        } else {
            if gosOnTile.isEmpty {
                GameObject.new(type: .weed,
                               coord: randomTileChunkCoord,
                               date: weed.scheduledDate)
            }
        }
    }

}

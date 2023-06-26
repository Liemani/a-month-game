//
//  InteractionZone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class AccessibleGOTracker {

    var character: Character

    private var dict: [Int: GameObject]
    var gos: some Sequence<GameObject> { self.dict.values }

    init(character: Character) {
        self.character = character
        self.dict = [:]
    }

    func contains(_ go: GameObject) -> Bool {
        return self.dict[go.id] != nil
    }

//    func gameObjectAtLocation(of touch: UITouch) -> GameObject? {
//        for go in self.gos {
//            if go.isAtLocation(of: touch) {
//                return go
//            }
//        }
//        return nil
//    }

    // MARK: - edit
    func add(_ gos: [GameObject]) {
        for go in gos {
            self.dict[go.id] = go
            self.activate(go)
        }
    }

    func add(_ go: GameObject) {
        self.dict[go.id] = go
        self.activate(go)
    }

    func remove(_ go: GameObject) {
        self.deactivate(go)
        self.dict[go.id] = nil
    }

    // MARK: - activate
    func activate(_ go: GameObject) {
        go.color = .green.withAlphaComponent(0.9)
        go.colorBlendFactor = Constant.accessibleGOColorBlendFactor
        go.isUserInteractionEnabled = true
    }

    func activateAll() {
        for go in self.gos {
            self.activate(go)
        }
    }

    func deactivate(_ go: GameObject) {
        go.colorBlendFactor = 0.0
        go.isUserInteractionEnabled = false
    }

    // MARK: - update
    func update(chunkContainer: ChunkContainer) {
        self.reset()

        for direction in Direction9.allCases {
            let tileChunkCoord = self.character.chunkCoord + direction.coord
            let chunkDirection = chunkContainer.chunkDirection(to: tileChunkCoord)!
            let tileAddr = tileChunkCoord.address.tile.value
            let chunk = chunkContainer.chunks[chunkDirection]

            guard let tileGOs = chunk.data.tileGOs(tileAddr: tileAddr) else {
                continue
            }

            for go in tileGOs {
                self.add(go)
            }
        }
    }

    private func reset() {
        for go in self.gos {
            self.deactivate(go)
        }
        self.dict.removeAll()
    }

}

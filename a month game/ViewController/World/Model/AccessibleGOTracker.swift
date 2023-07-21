//
//  InteractionZone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/28.
//

import Foundation
import SpriteKit

class AccessibleGOTracker {

    private var _gos: [Int: GameObject]
    var gos: some Sequence<GameObject> { self._gos.values }

    init() {
        self._gos = [:]
    }

    func contains(_ go: GameObject) -> Bool {
        return self._gos[go.id] != nil
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
            self._gos[go.id] = go
        }
    }

    func add(_ go: GameObject) {
        self._gos[go.id] = go
    }

    func remove(_ go: GameObject) {
        self._gos[go.id] = nil
    }

    // MARK: - update
    func update(chunkContainer: ChunkContainer) {
        self._gos.removeAll()

        let characterChunkCoord = Services.default.character.chunkCoord

        for direction in Direction9.allCases {
            let adjacentTileChunkCoord = characterChunkCoord + direction.coord

            guard let gos = Services.default.chunkContainer.items(
                at: adjacentTileChunkCoord) else {
                continue
            }

            for go in gos {
                if !go.type.isWalkable {
                    self.add(go)
                }
            }
        }
    }

}

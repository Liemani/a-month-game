//
//  ChunkData.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/26.
//

import Foundation

class ChunkData {

    var gos: [UInt8: [GameObject]]

    init() {
        self.gos = [:]
    }

    func tileGOs(tileAddr: UInt8) -> [GameObject]? {
        return self.gos[tileAddr]
    }

    func add(_ go: GameObject) {
        let goTileAddr = go.chunkCoord!.address.tile.value

        if self.gos[goTileAddr] == nil {
            self.gos[goTileAddr] = [go]
        } else {
            self.gos[goTileAddr]!.append(go)
        }
    }

    func remove(_ go: GameObject) {
        let goTileAddr = go.chunkCoord!.address.tile.value

        guard let tileGOs = self.gos[goTileAddr] else {
            return
        }

        if tileGOs.count != 1 {
            self.gos[goTileAddr]!.removeAll { $0 == go }
        } else {
            self.gos[goTileAddr] = nil
        }
    }

    func removeAll() {
        self.gos.removeAll()
    }

}

//
//  ChunkData.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/26.
//

import Foundation

class TileGameObjects: Sequence {

    var gos: [GameObject]

    var count: Int { self.gos.count }

    init(go: GameObject) {
        self.gos = [go]
    }

    func append(_ go: GameObject) {
        self.gos.append(go)
    }

    func remove(_ go: GameObject) {
        self.gos.removeAll { $0.id == go.id }
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        return self.gos.makeIterator()
    }

    subscript(index: Int) -> GameObject {
        get { self.gos[index] }
        set { self.gos[index] = newValue }
    }

}

struct ChunkData {

    var gos: [UInt8: TileGameObjects]

    init() {
        self.gos = [:]
    }

    func tileGOs(tileAddr: UInt8) -> TileGameObjects? {
        return self.gos[tileAddr]
    }

    mutating func add(_ go: GameObject) {
        let goTileAddr = go.chunkCoord!.address.tile.value

        if let tileGOs = self.gos[goTileAddr] {
            tileGOs.append(go)
        } else {
            self.gos[goTileAddr] = TileGameObjects(go: go)
        }
    }

    mutating func remove(_ go: GameObject) {
        let goTileAddr = go.chunkCoord!.address.tile.value

        guard let tileGOs = self.gos[goTileAddr] else {
            return
        }

        if tileGOs.count == 1 {
            self.gos[goTileAddr] = nil
        } else {
            tileGOs.remove(go)
        }
    }

    mutating func removeAll() {
        self.gos.removeAll()
    }

}
//
//  ChunkData.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/26.
//

import Foundation

//class TileGameObjects: Sequence {
//
//    typealias Element = GameObject
//
//    var gos: [GameObject]
//
//    var count: Int { self.gos.count }
//
//    init(go: GameObject) {
//        self.gos = [go]
//    }
//
//    func append(_ go: GameObject) {
//        self.gos.append(go)
//    }
//
//    func remove(_ go: GameObject) {
//        self.gos.removeAll { $0.id == go.id }
//    }
//
//    func makeIterator() -> some IteratorProtocol<GameObject> {
//        return self.gos.makeIterator()
//    }
//
//    subscript(index: Int) -> GameObject {
//        get { self.gos[index] }
//        set { self.gos[index] = newValue }
//    }
//
//}

struct ChunkData {

    var gos: [UInt8: [GameObject]]

    init() {
        self.gos = [:]
    }

    func tileGOs(tileAddr: UInt8) -> [GameObject]? {
        return self.gos[tileAddr]
    }

    mutating func add(_ go: GameObject) {
        let goTileAddr = go.chunkCoord!.address.tile.value

        if self.gos[goTileAddr] == nil {
            self.gos[goTileAddr] = [go]
        } else {
            self.gos[goTileAddr]!.append(go)
        }
    }

    mutating func remove(_ go: GameObject) {
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

    mutating func removeAll() {
        self.gos.removeAll()
    }

}

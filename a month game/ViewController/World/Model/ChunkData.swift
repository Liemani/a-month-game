//
//  ChunkData.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/26.
//

import Foundation

class ChunkData {

    typealias Coord = Coordinate<UInt8>

    var gos: [Coord: [GameObject]]

    init() {
        self.gos = [:]
    }

    func gos(at coord: Coord) -> [GameObject] {
        return self.gos[coord] ?? []
    }

    func add(_ go: GameObject, to coord: Coord) {
        if self.gos[coord] == nil {
            self.gos[coord] = [go]
        } else {
            self.gos[coord]!.append(go)
        }
    }

    func remove(_ go: GameObject, from coord: Coord) {
        guard let tileGOs = self.gos[coord] else {
            return
        }

        if tileGOs.count != 1 {
            self.gos[coord]!.removeAll { $0 == go }
        } else {
            self.gos[coord] = nil
        }
    }

    func removeAll() {
        self.gos.removeAll()
    }

}

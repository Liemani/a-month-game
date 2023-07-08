//
//  InventoryData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/08.
//

import Foundation

class InventoryData: Sequence {

    private var gos: [Int: GameObjectData]

    var id: Int!

    var count: Int!

    init() {
        self.gos = [:]
    }

    init(id: Int) {
        self.gos = [:]

        self.update(id: id)
    }

    func goData(at index: Int) -> GameObjectData? {
        return self.gos[index]
    }

    func update(id: Int) {
        self.gos.removeAll()

        self.id = id

        let goDatas = ServiceContainer.default.invServ.load(id: id)

        for goData in goDatas {
            self.gos[goData.invCoord!.index] = goData
        }

        self.count = goDatas.count
    }

    func add(_ goData: GameObjectData) {
        self.gos[goData.invCoord!.index] = goData
    }

    func remove(_ goData: GameObjectData) {
        self.gos[goData.invCoord!.index] = nil
    }

    func makeIterator() -> some IteratorProtocol<GameObjectData> {
        return self.gos.values.makeIterator()
    }
    
}

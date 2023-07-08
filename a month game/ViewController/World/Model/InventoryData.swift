//
//  InventoryData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/08.
//

import Foundation

class InventoryData {

    weak var inv: Inventory?

    private var goDatas: [Int: GameObjectData]

    var id: Int!

    var capacity: Int
    var count: Int { self.goDatas.count }
    var space: Int { self.capacity - self.count }

    init() {
        self.goDatas = [:]

        self.capacity = 0
    }

    init(id: Int, capacity: Int) {
        self.goDatas = [:]

        self.capacity = capacity

        self.update(id: id)
    }

    var emptyCoord: InventoryCoordinate? {
        for index in 0 ..< self.capacity {
            if self.goDatas[index] == nil {
                return InventoryCoordinate(self.id, index)
            }
        }

        return nil
    }

    func goData(at index: Int) -> GameObjectData? {
        return self.goDatas[index]
    }

    func update(id: Int) {
        self.goDatas.removeAll()
        
        self.id = id

        let goDatas = ServiceContainer.default.invServ.load(id: id)

        for goData in goDatas {
            self.goDatas[goData.invCoord!.index] = goData
        }
    }

    func clear() {
        self.goDatas.removeAll()
    }

    func add(_ goData: GameObjectData) {
        self.goDatas[goData.invCoord!.index] = goData
    }

    func remove(_ goData: GameObjectData) {
        self.goDatas[goData.invCoord!.index] = nil
    }

}

extension InventoryData: Sequence {

    func makeIterator() -> some IteratorProtocol<GameObjectData> {
        return self.goDatas.values.makeIterator()
    }
    
}

//
//  InventoryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/25.
//

import Foundation

class InventoryService {

    private var inventoryRepo: InventoryRepository!

    init(inventoryRepo: InventoryRepository) {
        self.inventoryRepo = inventoryRepo
    }

    func load(id: Int) -> [GameObjectData] {
        let goMOs = self.inventoryRepo.load(id: id)
        let goDatas = goMOs.compactMap {
            GameObjectData(from: $0)
        }
        return goDatas
    }

}

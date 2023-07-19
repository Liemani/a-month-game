//
//  InventoryService.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/25.
//

import Foundation

class InventoryService {

    func load(id: Int) -> [GameObjectData] {
        let goMOs = Repositories.default.invRepo.load(id: id)
        let goDatas = goMOs.compactMap {
            GameObjectData(from: $0)
        }

        return goDatas
    }

    func emptyIndex(id: Int) -> Int {
        var invCoordinateMOs = Repositories.default.invCoordDS.load(id: id)
        invCoordinateMOs.sort { $0.index < $1.index }
        var index = 0

        for invCoordMO in invCoordinateMOs {
            if invCoordMO.index == index {
                index += 1
            } else {
                break
            }
        }

        return index
    }

    func isEmpty(id: Int) -> Bool {
        let goMOs = Repositories.default.invRepo.load(id: id)
        return goMOs.count == 0
    }

}

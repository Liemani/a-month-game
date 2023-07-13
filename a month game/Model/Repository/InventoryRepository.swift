//
//  InventoryRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/25.
//

import Foundation
import CoreData

class InventoryRepository {

    private var goDS: GameObjectDataSource
    private var invCoordDS: InventoryCoordinateDataSource

    init(goDS: GameObjectDataSource,
         invCoordDS: InventoryCoordinateDataSource) {
        self.goDS = goDS
        self.invCoordDS = invCoordDS
    }

    func load(id: Int) -> [GameObjectMO] {
        let invCoordMOs = self.invCoordDS.load(id: id)
        let goMOs = invCoordMOs.compactMap { invCoordMO -> GameObjectMO? in
            return invCoordMO.gameObjectMO
        }
        return goMOs
    }

}

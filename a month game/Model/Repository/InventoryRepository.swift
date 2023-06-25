//
//  InventoryRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/25.
//

import Foundation
import CoreData

class InventoryRepository {

    private var goDataSource: GameObjectDataSource
    private var invCoordDataSource: InventoryCoordinateDataSource

    init(goDataSource: GameObjectDataSource,
         invCoordDataSource: InventoryCoordinateDataSource) {
        self.goDataSource = goDataSource
        self.invCoordDataSource = invCoordDataSource
    }

    func load(at invCoord: InventoryCoordinate) -> [GameObjectMO] {
        let invCoordMOs = self.invCoordDataSource.load(at: invCoord)
        let goMOs = invCoordMOs.compactMap { invCoordMO -> GameObjectMO? in
            return invCoordMO.gameObjectMO
        }
        return goMOs
    }

}

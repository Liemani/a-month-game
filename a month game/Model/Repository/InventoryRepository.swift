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

    func load(id: Int) -> [GameObjectMO] {
        let invCoordMOs = self.invCoordDataSource.load(id: id)
        let goMOs = invCoordMOs.compactMap { invCoordMO -> GameObjectMO? in
            return invCoordMO.gameObjectMO
        }
        return goMOs
    }

}

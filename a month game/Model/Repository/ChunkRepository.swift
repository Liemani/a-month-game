//
//  ChunkRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import CoreData

class ChunkRepository {

    private var goDataSource: GameObjectDataSource
    private var chunkCoordDataSource: ChunkCoordinateDataSource
    private var invCoordDataSource: InventoryCoordinateDataSource

    init(_ worldServiceContainer: WorldServiceContainer) {
        self.goDataSource = worldServiceContainer.goDataSource
        self.chunkCoordDataSource = worldServiceContainer.chunkCoordDataSource
        self.invCoordDataSource = worldServiceContainer.invCoordDataSource
    }

    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectMO] {
        let chunkCoordMOs = self.chunkCoordDataSource.load(at: chunkCoord)
        let goMOs = chunkCoordMOs.compactMap { chunkCoordMO -> GameObjectMO? in
            return chunkCoordMO.gameObjectMO
        }
        return goMOs
    }

    func load(at invCoord: InventoryCoordinate) -> [GameObjectMO] {
        let invCoordMOs = self.invCoordDataSource.load(at: invCoord)
        let goMOs = invCoordMOs.compactMap { invCoordMO -> GameObjectMO? in
            return invCoordMO.gameObjectMO
        }
        return goMOs
    }

}

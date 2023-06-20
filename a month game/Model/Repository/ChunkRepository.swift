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

    init(persistentContainer: LMIPersistentContainer) {
        self.goDataSource = GameObjectDataSource(persistentContainer)
        self.chunkCoordDataSource = ChunkCoordinateDataSource(persistentContainer)
        self.invCoordDataSource = InventoryCoordinateDataSource(persistentContainer)
    }

    func load(at coord: Coordinate<Int>) -> [GameObjectMO] {
        let chunkCoord = ChunkCoordinate(from: coord)
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

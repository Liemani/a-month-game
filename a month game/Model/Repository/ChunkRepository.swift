//
//  ChunkRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import CoreData

class ChunkRepository {

    private let goDS: GameObjectDataSource
    private let chunkCoordDS: ChunkCoordinateDataSource

    init(goDS: GameObjectDataSource,
         chunkCoordDS: ChunkCoordinateDataSource) {
        self.goDS = goDS
        self.chunkCoordDS = chunkCoordDS
    }

    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectMO] {
        let chunkCoordMOs = self.chunkCoordDS.load(at: chunkCoord)
        let goMOs = chunkCoordMOs.compactMap { chunkCoordMO -> GameObjectMO? in
            return chunkCoordMO.gameObjectMO
        }
        return goMOs
    }

}

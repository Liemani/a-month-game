//
//  ChunkRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation
import CoreData

class ChunkRepository {

    private let goDataSource: GameObjectDataSource
    private let chunkCoordDataSource: ChunkCoordinateDataSource

    init(goDataSource: GameObjectDataSource,
         chunkCoordDataSource: ChunkCoordinateDataSource) {
        self.goDataSource = goDataSource
        self.chunkCoordDataSource = chunkCoordDataSource
    }

    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectMO] {
        let chunkCoordMOs = self.chunkCoordDataSource.load(at: chunkCoord)
        let goMOs = chunkCoordMOs.compactMap { chunkCoordMO -> GameObjectMO? in
            return chunkCoordMO.gameObjectMO
        }
        return goMOs
    }

}

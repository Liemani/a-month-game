//
//  GameObjectRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import CoreData

class GameObjectRepository {

    private var goDataSource: GameObjectDataSource
    private var chunkCoordDataSource: ChunkCoordinateDataSource
    private var invCoordDataSource: InventoryCoordinateDataSource


    init(goDataSource: GameObjectDataSource,
         chunkCoordDataSource: ChunkCoordinateDataSource,
         invCoordDataSource: InventoryCoordinateDataSource) {
        self.goDataSource = goDataSource
        self.chunkCoordDataSource = chunkCoordDataSource
        self.invCoordDataSource = invCoordDataSource
    }

    func new(id: Int, type: GameObjectType) -> GameObjectMO {
        let goMO = self.goDataSource.new()

        goMO.id = Int32(id)
        goMO.typeID = Int32(type.rawValue)

        goMO.chunkCoord = nil
        goMO.invCoord = nil

        return goMO
    }

}

extension GameObjectMO {

    func update(to chunkCoord: ChunkCoordinate) {
        if let chunkCoordMO = self.chunkCoord {
            chunkCoordMO.update(chunkCoord)
        } else {
            let chunkCoordMO = WorldServiceContainer.default.chunkCoordDS.new()
            chunkCoordMO.update(chunkCoord)
            chunkCoordMO.gameObjectMO = self
            self.chunkCoord = chunkCoordMO
            self.invCoord = nil
        }
    }

    func update(to invCoord: InventoryCoordinate) {
        if let invCoordMO = self.invCoord {
            invCoordMO.update(invCoord)
        } else {
            let invCoordMO = WorldServiceContainer.default.invCoordDS.new()
            invCoordMO.update(invCoord)
            invCoordMO.gameObjectMO = self
            self.invCoord = invCoordMO
            self.chunkCoord = nil
        }
    }

    func delete() {
        WorldServiceContainer.default.persistentContainer.viewContext.delete(self)
    }

}

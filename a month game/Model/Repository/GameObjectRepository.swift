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

    func new(id: Int,
             type: GameObjectType,
             variant: Int,
             quality: Double,
             state: GameObjectState) -> GameObjectMO {
        let goMO = self.goDataSource.new()

        goMO.id = Int32(id)
        goMO.typeID = Int32((variant << 16) | type.rawValue)

        goMO.quality = quality
        goMO.state = state.rawValue

        goMO.chunkCoord = nil
        goMO.invCoord = nil

        return goMO
    }

}

extension GameObjectMO {

    var type: Int { Int(self.typeID & 0xffff) }
    var variant: Int { Int(UInt32(self.typeID) >> 16) }

    func update(to goType: GameObjectType) {
        self.typeID = Int32(goType.rawValue)
    }

    func update(to variant: Int) {
        self.typeID = Int32(truncatingIfNeeded: variant << 16) | self.typeID
    }

    func update(to state: GameObjectState) {
        self.state = state.rawValue
    }

    func update(to chunkCoord: ChunkCoordinate) {
        if let chunkCoordMO = self.chunkCoord {
            chunkCoordMO.update(chunkCoord)
        } else {
            let chunkCoordMO = ServiceContainer.default.chunkCoordDS.new()
            chunkCoordMO.update(chunkCoord)
            chunkCoordMO.gameObjectMO = self
            self.chunkCoord = chunkCoordMO

            if let invCoordMO = self.invCoord {
                invCoordMO.delete()
            }
        }
    }

    func update(to invCoord: InventoryCoordinate) {
        if let invCoordMO = self.invCoord {
            invCoordMO.update(invCoord)
        } else {
            let invCoordMO = ServiceContainer.default.invCoordDS.new()
            invCoordMO.update(invCoord)
            invCoordMO.gameObjectMO = self
            self.invCoord = invCoordMO
            
            if let chunkCoordMO = self.chunkCoord {
                chunkCoordMO.delete()
            }
        }
    }

    func delete() {
        ServiceContainer.default.persistentContainer.viewContext.delete(self)
    }

}

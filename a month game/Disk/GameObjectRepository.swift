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

    private var moContext: NSManagedObjectContext

    private var shouldContextSave: Bool

    init(persistentContainer: LMIPersistentContainer) {
        self.goDataSource = GameObjectDataSource(persistentContainer)
        self.chunkCoordDataSource = ChunkCoordinateDataSource(persistentContainer)
        self.invCoordDataSource = InventoryCoordinateDataSource(persistentContainer)

        self.moContext = persistentContainer.viewContext

        self.shouldContextSave = false
    }

    // MARK: - edit
    func new(id: Int, type: GameObjectType, coord: Coordinate<Int>) -> GameObjectMO {
        let goMO = self.goDataSource.new()

        goMO.id = Int32(id)
        goMO.typeID = Int32(type.rawValue)

        let chunkCoordMO = self.chunkCoordDataSource.new()
        let chunkCoord = ChunkCoordinate(from: coord)
        chunkCoordMO.update(chunkCoord)
        chunkCoordMO.gameObjectMO = goMO
        goMO.chunkCoord = chunkCoordMO

        self.shouldContextSave = true

        return goMO
    }

    func new(id: Int, type: GameObjectType, invCoord: InventoryCoordinate) -> GameObjectMO {
        let goMO = self.goDataSource.new()

        goMO.id = Int32(id)
        goMO.typeID = Int32(type.rawValue)

        let invCoordMO = self.invCoordDataSource.new()
        invCoordMO.update(invCoord)
        invCoordMO.gameObjectMO = goMO
        goMO.invCoord = invCoordMO

        self.shouldContextSave = true

        return goMO
    }

    func update(_ goMO: GameObjectMO, coord: Coordinate<Int>) {
        let chunkCoord = ChunkCoordinate(from: coord)
        if let chunkCoordMO = goMO.chunkCoord {
            chunkCoordMO.update(chunkCoord)
        } else {
            let chunkCoordMO = self.chunkCoordDataSource.new()
            chunkCoordMO.update(chunkCoord)
            chunkCoordMO.gameObjectMO = goMO
            goMO.chunkCoord = chunkCoordMO
            goMO.invCoord = nil
        }

        self.shouldContextSave = true
    }

    func update(_ goMO: GameObjectMO, invCoord: InventoryCoordinate) {
        if let invCoordMO = goMO.invCoord {
            invCoordMO.update(invCoord)
        } else {
            let invCoordMO = self.invCoordDataSource.new()
            invCoordMO.update(invCoord)
            invCoordMO.gameObjectMO = goMO
            goMO.invCoord = invCoordMO
            goMO.chunkCoord = nil
        }

        self.shouldContextSave = true
    }

    func delete(_ goMO: GameObjectMO) {
        self.moContext.delete(goMO)

        self.shouldContextSave = true
    }

    func contextSave() {
        try! self.moContext.save()
    }

    // MARK: - update
    func update() {
        guard self.shouldContextSave else { return }
        self.contextSave()
    }

}

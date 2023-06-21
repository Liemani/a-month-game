//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation
import CoreData

final class WorldServiceContainer {

    private static var _default: WorldServiceContainer?
    static var `default`: WorldServiceContainer { self._default! }

    static func set(worldName: String) {
        let isWorldExist = WorldDirectoryUtility.default.isExist(worldName: worldName)

        WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        let worldServiceContainer = WorldServiceContainer(worldName: worldName)
        self._default = worldServiceContainer

        if !isWorldExist {
            WorldGenerator.generate()
        }
    }

    static func free() {
        self._default = nil
    }

    var idGeneratorServ: IDGeneratorService
    var chunkServ: ChunkService

    var goRepo: GameObjectRepository
    var chunkRepo: ChunkRepository
    var worldDataRepo: WorldDataRepository

    var goDS: GameObjectDataSource
    var chunkCoordDS: ChunkCoordinateDataSource
    var invCoordDS: InventoryCoordinateDataSource
    var worldDataDS: WorldDataDataSource

    var persistentContainer: LMIPersistentContainer
    var moContext: NSManagedObjectContext

    init(worldName: String) {
        let worldDirURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        let worldDataModelName = Constant.Name.worldDataModel
        let persistentContainer = LMIPersistentContainer(name: worldDataModelName)
        persistentContainer.setUp(to: worldDirURL)
        self.persistentContainer = persistentContainer

        let moContext = persistentContainer.viewContext
        self.moContext = moContext

        // MARK: data source
        let goDS = GameObjectDataSource(persistentContainer)
        self.goDS = goDS

        let chunkCoordDS = ChunkCoordinateDataSource(persistentContainer)
        self.chunkCoordDS = chunkCoordDS

        let invCoordDS = InventoryCoordinateDataSource(persistentContainer)
        self.invCoordDS = invCoordDS

        let worldDataDS = WorldDataDataSource(worldDirURL: worldDirURL)
        self.worldDataDS = worldDataDS

        // MARK: repository
        let goRepo = GameObjectRepository(
            goDataSource: goDS,
            chunkCoordDataSource: chunkCoordDS,
            invCoordDataSource: invCoordDS)
        self.goRepo = goRepo

        let chunkRepo = ChunkRepository(
            goDataSource: goDS,
            chunkCoordDataSource: chunkCoordDS,
            invCoordDataSource: invCoordDS)
        self.chunkRepo = chunkRepo

        let worldDataRepo = WorldDataRepository(worldDataDataSource: worldDataDS)
        self.worldDataRepo = worldDataRepo

        // MARK: service
        let idGeneratorServ = IDGeneratorService(worldDataRepository: worldDataRepo)
        self.idGeneratorServ = idGeneratorServ

        let chunkServ = ChunkService(chunkRepository: chunkRepo)
        self.chunkServ = chunkServ

#if DEBUG
        print(worldDirURL)
#endif
    }

}

//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation
import CoreData

final class WorldServiceContainer {

    static var `default` = WorldServiceContainer()

    var idGeneratorService: IDGeneratorService!
    var chunkService: ChunkService!

    var goRepository: GameObjectRepository!
    var chunkRepository: ChunkRepository!
    var worldDataRepository: WorldDataRepository!

    var goDataSource: GameObjectDataSource!
    var chunkCoordDataSource: ChunkCoordinateDataSource!
    var invCoordDataSource: InventoryCoordinateDataSource!
    var worldDataDataSource: WorldDataDataSource!

    var persistentContainer: LMIPersistentContainer!
    var moContext: NSManagedObjectContext!

    init() { }

    func set(worldName: String) {
        let worldDirURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        let isWorldExist = WorldDirectoryUtility.default.isExist(worldName: worldName)

        WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        let worldDataModelName = Constant.Name.worldDataModel
        let persistentContainer = LMIPersistentContainer(name: worldDataModelName)
        persistentContainer.setUp(to: worldDirURL)

        self.persistentContainer = persistentContainer
        self.moContext = persistentContainer.viewContext

        self.goDataSource = GameObjectDataSource(persistentContainer)
        self.chunkCoordDataSource = ChunkCoordinateDataSource(persistentContainer)
        self.invCoordDataSource = InventoryCoordinateDataSource(persistentContainer)
        self.worldDataDataSource = WorldDataDataSource(worldDirURL: worldDirURL)

        self.goRepository = GameObjectRepository(self)
        self.chunkRepository = ChunkRepository(self)
        self.worldDataRepository = WorldDataRepository(self)

        self.idGeneratorService = IDGeneratorService(self)
        self.chunkService = ChunkService(self)

        if !isWorldExist {
            WorldGenerator.generate(self)
        }

#if DEBUG
        print(worldDirURL)
#endif
    }

}

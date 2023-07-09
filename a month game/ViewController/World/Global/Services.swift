//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation
import CoreData

final class Services {

    private static var _default: Services?
    static var `default`: Services { self._default! }

    static func set(worldName: String) {
        if self._default == nil {
            self._default = Services(worldName: worldName)
        }
    }

    static func free() {
        self._default = nil
    }

    let interactionMasteryServ: InteractionMasteryService
    let goInteractionMasteryServ: GOInteractionMasteryService
    let craftMasteryServ: CraftMasteryService
    let idGeneratorServ: IDGeneratorService
    let chunkServ: ChunkService
    let invServ: InventoryService

    let interactionMasteryRepo: InteractionMasteryRepository
    let goInteractionMasteryRepo: GOInteractionMasteryRepository
    let craftMasteryRepo: CraftMasteryRepository
    let worldDataRepo: WorldDataRepository
    let goRepo: GameObjectRepository
    let chunkRepo: ChunkRepository
    let invRepo: InventoryRepository

    let interactionMasteryDS: InteractionMasteryDataSource
    let goInteractionMasteryDS: GOInteractionMasteryDataSource
    let craftMasteryDS: CraftMasteryDataSource
    let worldDataDS: WorldDataDataSource
    let goDS: GameObjectDataSource
    let chunkCoordDS: ChunkCoordinateDataSource
    let invCoordDS: InventoryCoordinateDataSource

    let persistentContainer: LMIPersistentContainer
    let moContext: NSManagedObjectContext

    init(worldName: String) {
        let worldDirURL = FileUtility.default.worldDirURL(of: worldName)

        let worldDataModelName = Constant.Name.worldDataModel
        let persistentContainer = LMIPersistentContainer(name: worldDataModelName)
        persistentContainer.setUp(to: worldDirURL)
        self.persistentContainer = persistentContainer

        let moContext = persistentContainer.viewContext
        self.moContext = moContext

        // MARK: data source
        let interactionMasteryDS = InteractionMasteryDataSource(moContext)
        self.interactionMasteryDS = interactionMasteryDS

        let goInteractionMasteryDS = GOInteractionMasteryDataSource(moContext)
        self.goInteractionMasteryDS = goInteractionMasteryDS

        let craftMasteryDS = CraftMasteryDataSource(moContext)
        self.craftMasteryDS = craftMasteryDS

        let worldDataDS = WorldDataDataSource(worldDirURL: worldDirURL)
        self.worldDataDS = worldDataDS

        let goDS = GameObjectDataSource(moContext)
        self.goDS = goDS

        let chunkCoordDS = ChunkCoordinateDataSource(moContext)
        self.chunkCoordDS = chunkCoordDS

        let invCoordDS = InventoryCoordinateDataSource(moContext)
        self.invCoordDS = invCoordDS

        // MARK: repository
        let interactionMasteryRepo = InteractionMasteryRepository(interactionMasteryDS: interactionMasteryDS)
        self.interactionMasteryRepo = interactionMasteryRepo

        let goInteractionMasteryRepo = GOInteractionMasteryRepository(goInteractionMasteryDS: goInteractionMasteryDS)
        self.goInteractionMasteryRepo = goInteractionMasteryRepo

        let craftMasteryRepo = CraftMasteryRepository(craftMasteryDS: craftMasteryDS)
        self.craftMasteryRepo = craftMasteryRepo

        let worldDataRepo = WorldDataRepository(worldDataDataSource: worldDataDS)
        self.worldDataRepo = worldDataRepo

        let goRepo = GameObjectRepository(
            goDS: goDS,
            chunkCoordDS: chunkCoordDS,
            invCoordDS: invCoordDS)
        self.goRepo = goRepo

        let chunkRepo = ChunkRepository(
            goDS: goDS,
            chunkCoordDS: chunkCoordDS)
        self.chunkRepo = chunkRepo

        let invRepo = InventoryRepository(
            goDS: goDS,
            invCoordDS: invCoordDS)
        self.invRepo = invRepo

        // MARK: service
        let interactionMasteryServ = InteractionMasteryService(dataSource: interactionMasteryDS)
        self.interactionMasteryServ = interactionMasteryServ

        let goInteractionMasteryServ = GOInteractionMasteryService(dataSource: goInteractionMasteryDS)
        self.goInteractionMasteryServ = goInteractionMasteryServ

        let craftMasteryServ = CraftMasteryService(dataSource: craftMasteryDS)
        self.craftMasteryServ = craftMasteryServ

        let idGeneratorServ = IDGeneratorService(worldDataRepository: worldDataRepo)
        self.idGeneratorServ = idGeneratorServ

        let chunkServ = ChunkService(chunkRepo: chunkRepo)
        self.chunkServ = chunkServ

        let invServ = InventoryService(inventoryRepo: invRepo)
        self.invServ = invServ

#if DEBUG
        print(worldDirURL)
#endif
    }

}

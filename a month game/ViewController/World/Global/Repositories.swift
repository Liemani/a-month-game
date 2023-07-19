//
//  Repositories.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/19.
//

import Foundation
import CoreData

class Repositories {

    private static var _default: Repositories?
    static var `default`: Repositories { self._default! }

    static func set(worldName: String) {
        if self._default == nil {
            self._default = Repositories(worldName: worldName)
        }
    }

    static func free() {
        self._default = nil
    }

    let interactionMasteryRepo: InteractionMasteryRepository
    let goInteractionMasteryRepo: GOInteractionMasteryRepository
    let craftMasteryRepo: CraftMasteryRepository
    let worldDataRepo: WorldDataRepository
    let goRepo: GameObjectRepository
    let chunkRepo: ChunkRepository
    let invRepo: InventoryRepository
    let chunkIsGeneratedRepo: ChunkIsGeneratedRepository

    let interactionMasteryDS: InteractionMasteryDataSource
    let goInteractionMasteryDS: GOInteractionMasteryDataSource
    let craftMasteryDS: CraftMasteryDataSource
    let worldDataDS: WorldDataDataSource
    let goDS: GameObjectDataSource
    let chunkCoordDS: ChunkCoordinateDataSource
    let invCoordDS: InventoryCoordinateDataSource
    let chunkIsGeneratedDS: ChunkIsGeneratedDataSource

    let persistentContainer: LMIPersistentContainer
    let moContext: NSManagedObjectContext

    init(worldName: String) {
        let worldDirURL = FileUtility.default.worldDirURL(of: worldName)

        let worldDataModelName = Constant.Name.worldDataModel
        let persistentContainer = LMIPersistentContainer(name: worldDataModelName)
        persistentContainer.setUp(to: worldName)
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

        let chunkIsGeneratedDS = ChunkIsGeneratedDataSource(moContext)
        self.chunkIsGeneratedDS = chunkIsGeneratedDS

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

        let chunkIsGeneratedRepo = ChunkIsGeneratedRepository(
            chunkIsGeneratedDS: chunkIsGeneratedDS)
        self.chunkIsGeneratedRepo = chunkIsGeneratedRepo

#if DEBUG
        print(worldDirURL)
#endif
    }

}

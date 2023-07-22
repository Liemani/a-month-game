//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

final class Services {

    private static var _default: Services?
    static var `default`: Services { self._default! }

    static func set() {
        if self._default == nil {
            self._default = Services()
            Services.default.setUp()
        }
    }

    static func free() {
        self._default = nil
    }

    let action: ActionService

    let movingLayer: MovingLayerService
    let character: CharacterService

    let interactionMastery: InteractionMasteryService
    let goInteractionMastery: GOInteractionMasteryService
    let craftMastery: CraftMasteryService

    let idGenerator: IDGeneratorService

    let chunkContainer: ChunkContainerService
    let chunk: ChunkService
    let accessibleGOTracker: AccessibleGOTrackerService

    let inv: InventoryService
    let go: GameObjectService

    init() {
        self.action = ActionService()

        self.character = CharacterService()
        self.movingLayer = MovingLayerService()

        self.interactionMastery = InteractionMasteryService()
        self.goInteractionMastery = GOInteractionMasteryService()
        self.craftMastery = CraftMasteryService()

        self.idGenerator = IDGeneratorService()

        self.chunkContainer = ChunkContainerService()
        self.chunk = ChunkService()
        self.accessibleGOTracker = AccessibleGOTrackerService()

        self.inv = InventoryService()

        self.go = GameObjectService()
    }

    func setUp() {
        self.character.setUp()
    }

}

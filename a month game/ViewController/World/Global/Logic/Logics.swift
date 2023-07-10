//
//  Logics.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class Logics {

    private static var _default: Logics?
    static var `default`: Logics { self._default! }

    static func set(scene: WorldScene,
                    ui: SKNode,
                    invInv: GameObjectInventory,
                    fieldInv: GameObjectInventory,
                    infoWindow: InfoWindow,
                    character: Character,
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker) {
        self._default = Logics(scene: scene,
                               ui: ui,
                               invInv: invInv,
                               fieldInv: fieldInv,
                               infoWindow: infoWindow,
                               character: character,
                               chunkContainer: chunkContainer,
                               invContainer: invContainer,
                               accessibleGOTracker: accessibleGOTracker)
    }

    static func free() {
        self._default = nil
    }

    let touch: TouchLogics
    let scene: SceneLogic

    let mastery: MasteryLogic

    let infoWindow: InfoWindowLogic

    let character: CharacterLogic

    let invContainer: InventoryContainerLogic
    let chunkContainer: ChunkContainerLogic
    let accessibleGOTracker: AccessibleGOTrackerLogic

    let go: GameObjectLogic
    let goData: GameObjectDataLogic

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         infoWindow: InfoWindow,
         character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.touch = TouchLogics()
        self.scene = SceneLogic()

        self.mastery = MasteryLogic()

        self.infoWindow = InfoWindowLogic(infoWindow: infoWindow,
                                          character: character)

        self.character = CharacterLogic(character: character)

        self.invContainer = InventoryContainerLogic(invContainer: invContainer)
        self.chunkContainer = ChunkContainerLogic(chunkContainer: chunkContainer)
        self.accessibleGOTracker = AccessibleGOTrackerLogic(tracker: accessibleGOTracker)

        self.go = GameObjectLogic()
        self.goData = GameObjectDataLogic()
    }

}

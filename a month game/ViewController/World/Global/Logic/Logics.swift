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
                    world: SKNode,
                    character: Character,
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker,
                    leftGOTracker: LeftGOTracker) {
        self._default = Logics(scene: scene,
                               ui: ui,
                               invInv: invInv,
                               fieldInv: fieldInv,
                               infoWindow: infoWindow,
                               world: world,
                               character: character,
                               chunkContainer: chunkContainer,
                               invContainer: invContainer,
                               accessibleGOTracker: accessibleGOTracker,
                               leftGOTracker: leftGOTracker)
    }

    static func free() {
        self._default = nil
    }

    let touch: TouchLogics
    let scene: SceneLogic

    let mastery: MasteryLogic

    let craft: CraftLogic

    let infoWindow: InfoWindowLogic

    let world: WorldLogic
    let character: CharacterLogic

    let invContainer: InventoryContainerLogic
    let chunkContainer: ChunkContainerLogic

    let accessibleGOTracker: AccessibleGOTrackerLogic
    let leftGOTracker: LeftGOTrackerLogic

    let go: GameObjectLogic
    let goData: GameObjectDataLogic

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         infoWindow: InfoWindow,
         world: SKNode,
         character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker,
         leftGOTracker: LeftGOTracker) {
        self.touch = TouchLogics()
        self.scene = SceneLogic(scene: scene)

        self.mastery = MasteryLogic()

        self.craft = CraftLogic()

        self.infoWindow = InfoWindowLogic(infoWindow: infoWindow)

        self.world = WorldLogic(world: world)
        self.character = CharacterLogic(character: character)

        self.invContainer = InventoryContainerLogic(invContainer: invContainer)
        self.chunkContainer = ChunkContainerLogic(chunkContainer: chunkContainer)

        self.accessibleGOTracker = AccessibleGOTrackerLogic(tracker: accessibleGOTracker)
        self.leftGOTracker = LeftGOTrackerLogic(tracker: leftGOTracker)

        self.go = GameObjectLogic()
        self.goData = GameObjectDataLogic()
    }

}

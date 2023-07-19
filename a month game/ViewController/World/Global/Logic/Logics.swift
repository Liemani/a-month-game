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
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker) {
        self._default = Logics(scene: scene,
                               ui: ui,
                               invInv: invInv,
                               fieldInv: fieldInv,
                               infoWindow: infoWindow,
                               world: world,
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

    let craft: CraftLogic

    let infoWindow: InfoWindowLogic

    let world: WorldLogic

    let invContainer: InventoryContainerLogic
    let chunkContainer: ChunkContainerLogic

    let accessibleGOTracker: AccessibleGOTrackerLogic

    let goData: GameObjectDataLogic

    let action: ActionLogic

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         infoWindow: InfoWindow,
         world: SKNode,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.touch = TouchLogics()
        self.scene = SceneLogic(scene: scene)

        self.mastery = MasteryLogic()

        self.craft = CraftLogic()

        self.infoWindow = InfoWindowLogic(infoWindow: infoWindow)

        self.world = WorldLogic(world: world)

        self.invContainer = InventoryContainerLogic(invContainer: invContainer)
        self.chunkContainer = ChunkContainerLogic(chunkContainer: chunkContainer)

        self.accessibleGOTracker = AccessibleGOTrackerLogic(tracker: accessibleGOTracker)

        self.goData = GameObjectDataLogic()

        self.action = ActionLogic()
    }

}

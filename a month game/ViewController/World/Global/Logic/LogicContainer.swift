//
//  LogicContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class LogicContainer {

    private static var _default: LogicContainer?
    static var `default`: LogicContainer { self._default! }

    static func set(scene: WorldScene,
                    ui: SKNode,
                    invInv: GameObjectInventory,
                    fieldInv: GameObjectInventory,
                    character: Character,
                    chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer,
                    accessibleGOTracker: AccessibleGOTracker) {
        self._default = LogicContainer(scene: scene,
                                       ui: ui,
                                       invInv: invInv,
                                       fieldInv: fieldInv,
                                       character: character,
                                       chunkContainer: chunkContainer,
                                       invContainer: invContainer,
                                       accessibleGOTracker: accessibleGOTracker)
    }

    static func free() {
        self._default = nil
    }

    let touch: TouchLogicContainer
    let scene: SceneLogic

    let character: CharacterLogic

    let invContainer: InventoryContainerLogic
    let chunkContainer: ChunkContainerLogic
    let accessibleGOTracker: AccessibleGOTrackerLogic

    let go: GameObjectLogic

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         character: Character,
         chunkContainer: ChunkContainer,
         invContainer: InventoryContainer,
         accessibleGOTracker: AccessibleGOTracker) {
        self.touch = TouchLogicContainer()
        self.scene = SceneLogic()

        self.character = CharacterLogic(character: character)

        self.invContainer = InventoryContainerLogic(invContainer: invContainer)
        self.chunkContainer = ChunkContainerLogic(chunkContainer: chunkContainer)
        self.accessibleGOTracker = AccessibleGOTrackerLogic(tracker: accessibleGOTracker)

        self.go = GameObjectLogic()
    }

}

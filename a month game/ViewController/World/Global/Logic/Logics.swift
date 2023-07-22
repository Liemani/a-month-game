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
                    invContainer: InventoryContainer) {
        self._default = Logics(scene: scene,
                               ui: ui,
                               invInv: invInv,
                               fieldInv: fieldInv,
                               infoWindow: infoWindow,
                               world: world,
                               invContainer: invContainer)
    }

    static func free() {
        self._default = nil
    }

    let scene: SceneLogic

    let mastery: MasteryLogic

    let craft: CraftLogic

    let infoWindow: InfoWindowLogic

    let world: WorldLogic

    let invContainer: InventoryContainerLogic

    let goData: GameObjectDataLogic

    init(scene: WorldScene,
         ui: SKNode,
         invInv: GameObjectInventory,
         fieldInv: GameObjectInventory,
         infoWindow: InfoWindow,
         world: SKNode,
         invContainer: InventoryContainer) {
        self.scene = SceneLogic(scene: scene)

        self.mastery = MasteryLogic()

        self.craft = CraftLogic()

        self.infoWindow = InfoWindowLogic(infoWindow: infoWindow)

        self.world = WorldLogic(world: world)

        self.invContainer = InventoryContainerLogic(invContainer: invContainer)

        self.goData = GameObjectDataLogic()
    }

}

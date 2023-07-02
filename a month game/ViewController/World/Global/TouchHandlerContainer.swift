//
//  TouchHandlerContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation

class TouchHandlerContainer {

    private static var _default: TouchHandlerContainer?
    static var `default`: TouchHandlerContainer { self._default! }

    static func set(chunkContainer: ChunkContainer,
                    invContainer: InventoryContainer) {
        self._default = TouchHandlerContainer(chunkContainer: chunkContainer,
                                              invContainer: invContainer)
    }

    static func free() { self._default = nil }

    var activatedGO: GameObject?

    let goHandler: GameObjectTouchHandler
    let fieldHandler: FieldTouchHandler
    let invTouchHandler: InventoryTouchHandler
    let craftTouchHandler: CraftTouchHandler

    init(chunkContainer: ChunkContainer, invContainer: InventoryContainer) {
        self.goHandler = GameObjectTouchHandler()
        self.fieldHandler = FieldTouchHandler(chunkContainer: chunkContainer)
        self.invTouchHandler = InventoryTouchHandler()
        self.craftTouchHandler = CraftTouchHandler(invContainer: invContainer)
    }

}

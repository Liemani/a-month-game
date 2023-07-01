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

    static func set(chunkContainer: ChunkContainer) { self._default = TouchHandlerContainer(chunkContainer: chunkContainer) }
    static func free() { self._default = nil }

    var activatedGO: GameObject?

    let goHandler: GameObjectTouchHandler
    let fieldHandler: FieldTouchHandler
//    let inventoryTouchHandler: InventoryTouchHandler

    init(chunkContainer: ChunkContainer) {
        self.goHandler = GameObjectTouchHandler()
        self.fieldHandler = FieldTouchHandler(chunkContainer: chunkContainer)
//        self.inventoryTouchHandler = InventoryTouchHandler()
    }

}

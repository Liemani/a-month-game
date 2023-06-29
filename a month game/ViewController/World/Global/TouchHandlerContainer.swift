//
//  TouchEventHandlerContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/29.
//

import Foundation

class TouchHandlerContainer {

    private static var _default: TouchHandlerContainer?
    static var `default`: TouchHandlerContainer { self._default! }

    static func set() { self._default = TouchHandlerContainer() }
    static func free() { self._default = nil }

    let goTouchHandler: GameObjectTouchHandler
//    let fieldTouchHandler: FieldTouchEventHandler
//    let inventoryTouchHandler: InventoryTouchEventHandler

    init() {
        self.goTouchHandler = GameObjectTouchHandler()
//        self.fieldTouchEventHandler = FieldTouchEventHandler()
//        self.inventoryTouchEventHandler = InventoryTouchEventHandler()
    }

}

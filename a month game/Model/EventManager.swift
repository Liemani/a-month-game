//
//  EventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

class EventManager {

    private static var _default: EventManager?
    static var `default`: EventManager { self._default! }

    static func set() { self._default = EventManager() }
    static func free() { self._default = nil }

    let touchEventHandlerManager: TouchEventHandlerManager
    let sceneEventQueue: QueueObject<SceneEvent>

    init() {
        self.touchEventHandlerManager = TouchEventHandlerManager()
        self.sceneEventQueue = QueueObject(size: Constant.sceneEventQueueSize)
    }

}

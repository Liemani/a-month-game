//
//  EventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

struct ShouldUpdate : OptionSet {
    let rawValue: Int

    static let interaction = ShouldUpdate(rawValue: 0x1 << 0)
    static let craftWindow = ShouldUpdate(rawValue: 0x1 << 1)
}


class EventManager {

    private static var _default: EventManager?
    static var `default`: EventManager { self._default! }

    static func set() { self._default = EventManager() }
    static func free() { self._default = nil }

    let touchBeganEventQueue: QueueObject<TouchEvent>
    let touchBeganEventHandlerManager: TouchEventHandlerManager

    var shouldUpdate: ShouldUpdate

//    let sceneEventQueue: QueueObject<SceneEvent>

    init() {
        self.touchBeganEventQueue = QueueObject(size: Constant.touchEventQueueSize)
        self.touchBeganEventHandlerManager = TouchEventHandlerManager()

        self.shouldUpdate = []

//        self.sceneEventQueue = QueueObject(size: Constant.sceneEventQueueSize)
    }

}

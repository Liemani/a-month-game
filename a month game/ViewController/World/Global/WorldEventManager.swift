//
//  SceneEvent.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

enum WorldEventType {
    
    case accessableGOTrackerAdd
    case accessableGOTrackerRemove
    case gameObjectMoveTouchEnded
    case gameObjectMoveToCharacter
    case gameObjectMoveToChunk

}

//      case GameObjectRemoveFromChunkWorldEventHandler
//      case GameObjectMoveToCharacterWorldEventHandler
//      case GameObjectMoveToChunkWorldEventHandler

class WorldEvent {

    let type: WorldEventType
    let udata: Any?

    let sender: Any

    init(type: WorldEventType, udata: Any?, sender: Any) {
        self.type = type
        self.udata = udata
        self.sender = sender
    }

}

class WorldEventManager {

    private static var _default: WorldEventManager?
    static var `default`: WorldEventManager { self._default! }

    static func set() { self._default = WorldEventManager() }
    static func free() { self._default = nil }

    private var queue: Queue<WorldEvent>

    init() {
        self.queue = Queue(size: Constant.worldEventQueueSize)
    }

    func enqueue(_ event: WorldEvent) {
        self.queue.enqueue(event)
    }

    func dequeue() -> WorldEvent? {
        return self.queue.dequeue()
    }

}

protocol WorlEventHandler {

    func handle()

}

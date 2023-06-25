//
//  SceneEvent.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

enum EventType {
    
    case characterTouchBegan
    case gameObjectTouchBegan
    case gameObjectMoveTouchBegan
    case gameObjectMoveTouchEnded
    case gameObjectAddToCharacter
    case gameObjectAddToChunk
    case accessableGOTrackerAdd
    case accessableGOTrackerRemove

}

class Event {

    let type: EventType
    let udata: Any?

    let sender: Any

    init(type: EventType, udata: Any?, sender: Any) {
        self.type = type
        self.udata = udata
        self.sender = sender
    }

}

class EventManager {

    private static var _default: EventManager?
    static var `default`: EventManager { self._default! }

    static func set() { self._default = EventManager() }
    static func free() { self._default = nil }

    private var queue: Queue<Event>

    init() {
        self.queue = Queue(size: Constant.worldEventQueueSize)
    }

    func enqueue(_ event: Event) {
        self.queue.enqueue(event)
    }

    func dequeue() -> Event? {
        return self.queue.dequeue()
    }

}

protocol WorlEventHandler {

    func handle()

}

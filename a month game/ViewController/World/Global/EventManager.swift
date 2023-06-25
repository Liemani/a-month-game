//
//  SceneEvent.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

enum EventType: Int, CaseIterable {
    
    case characterTouchBegan
    case gameObjectTouchBegan
    case gameObjectMoveTouchBegan
    case gameObjectMoveTouchEnded

    case gameObjectAddToCharacter
    case gameObjectAddToChunk
    case gameObjectMoveToUI
    case accessableGOTrackerAdd
    case accessableGOTrackerRemove

//    game object
//        make new
//        move to inventory
//        move to chunk container
//        interact
//        interact with game object
//
//    accessable go tracker
//        add
//        remove

    static let eventHandlers: [(WorldScene, Event) -> Void] = [
        { scene, event in // characterTouchBegan
            let handler = CharacterMoveTouchEventHandler(
                touch: event.udata as! UITouch,
                worldScene: scene,
                character: scene.character)
            if TouchEventHandlerManager.default.add(handler) {
                handler.touchBegan()
            }
        },
        { scene, event in // gameObjectTouchBegan
            let handler = GameObjectTouchEventHandler(
                touch: event.udata as! UITouch,
                go: event.sender as! GameObject)
            if TouchEventHandlerManager.default.add(handler) {
                handler.touchBegan()
            }
        },
        { scene, event in // gameObjectMoveTouchBegan
            let handler = GameObjectMoveTouchEventHandler(
                touch: event.udata as! UITouch,
                go: event.sender as! GameObject)
            if TouchEventHandlerManager.default.add(handler) {
                handler.touchBegan()
            }
        },
        { scene, event in // gameObjectMoveTouchEnded
            let handler = GameObjectMoveTouchEndedEventHandler(
                touch: event.udata as! UITouch,
                go: event.sender as! GameObject,
                chunkContainer: scene.chunkContainer)
            handler.handle()
        },
        { scene, event in // gameObjectAddToCharacter
            scene.character.addChild(event.sender as! GameObject)
        },
        { scene, event in // gameObjectAddToChunk
            let go = event.sender as! GameObject
            go.removeFromParent()
            scene.chunkContainer.add(go)
        },
        { scene, event in // gameObjectMoveToUI
            scene.character.move(toParent: event.sender as! GameObject)
        },
        { scene, event in // accessableGOTrackerAdd
            scene.accessableGOTracker.add(event.sender as! GameObject)
        },
        { scene, event in // accessableGOTrackerRemove
            scene.accessableGOTracker.remove(event.sender as! GameObject)
        },
    ]

    var handler: (WorldScene, Event) -> Void {
        return EventType.eventHandlers[self]
    }

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

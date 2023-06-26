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

    case gameObjectAddToChunk
    case gameObjectMoveToUI
    case gameObjectInteract
    case accessibleGOTrackerAdd
    case accessibleGOTrackerRemove

    /* NEED EVENT HANDLER
       game object
           move to chunk
           move to inventory
           interact
           interact with game object

       accessible go tracker
           add
           remove
-
game object pop info window
    open info window

game object move ended
    if any GO is at the location of touch
        game object fail put
    else
        if chunk is touched
            if touched tile is accessible
                put GO to touched tile
            else
                GO fail put
        else inv is touched
            put GO to inv

game object fail put
    if GO was on the tile
        if the tile is accessible
            move GO to tile
//          else if character inv has space
//              move GO to character inv
//          else
//              drop at the position of character
    else if GO was on the inventory
        if the inv is accessible
            put GO to inv
//          else if character inv has space
//              move GO to character inv
//          else
//              drop at the position of character
    else if GO has no coord
//          if character inv has space
//              move GO to character inv
//          else
//              drop at the position of character
    */

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
        { scene, event in // gameObjectAddToChunk
            let go = event.sender as! GameObject
            go.removeFromParent()
            scene.chunkContainer.add(go)
        },
        { scene, event in // gameObjectMoveToUI
            let go = event.sender as! GameObject
            go.move(toParent: scene.ui)
        },
        { scene, event in // case gameObjectInteract
            print("interact go")
        },
        { scene, event in // accessibleGOTrackerAdd
            scene.accessibleGOTracker.add(event.sender as! GameObject)
        },
        { scene, event in // accessibleGOTrackerRemove
            scene.accessibleGOTracker.remove(event.sender as! GameObject)
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

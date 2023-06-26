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
    case gameObjectMoveTouchEndedAtField
    case gameObjectMoveTouchEndedAtInv
    case gameObjectMoveToBelong
    case gameObjectMoveToBelongField
    case gameObjectMoveToBelongInv
    case gameObjectTake
    case gameObjectMoveToUI
    case gameObjectInteract
    case gameObjectInteractToGO
    case accessibleGOTrackerAdd
    case accessibleGOTrackerRemove

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
            let go = event.sender as! GameObject
            let touch = event.udata as! UITouch

            let characterChunkCoord = scene.character.chunkCoord

            if let touchedTileChunkCoord = scene.chunkContainer.coordAtLocation(of: touch),
               touchedTileChunkCoord.coord.isAdjacent(to: characterChunkCoord.coord) {
                let event = Event(type: .gameObjectMoveTouchEndedAtField,
                                  udata: touchedTileChunkCoord,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            }

            if let touchedInvCoord = scene.invContainer.coordAtLocation(of: touch) {
                let event = Event(type: .gameObjectMoveTouchEndedAtInv,
                                  udata: touchedInvCoord,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            }

            let event = Event(type: .gameObjectMoveToBelong,
                              udata: nil,
                              sender: go)
            EventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectMoveTouchEndedAtField
            let go = event.sender as! GameObject
            let touchedTileChunkCoord = event.udata as! ChunkCoordinate

            if let targetGO = scene.chunkContainer.item(at: touchedTileChunkCoord) {
                let event = Event(type: .gameObjectInteractToGO,
                                  udata: targetGO,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            } else {
                go.data.set(chunkCoord: touchedTileChunkCoord)

                let event = Event(type: .gameObjectMoveToBelongField,
                                  udata: nil,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            }
        },

        { scene, event in // gameObjectMoveTouchEndedAtInv
            let go = event.sender as! GameObject
            let invCoord = event.udata as! InventoryCoordinate

            if let targetGO = scene.invContainer.item(at: invCoord) {
                let event = Event(type: .gameObjectInteractToGO,
                                  udata: targetGO,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            } else {
                go.data.set(invCoord: invCoord)

                let event = Event(type: .gameObjectMoveToBelongInv,
                                  udata: nil,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            }
        },

        { scene, event in // gameObjectMoveToBelong
            let go = event.sender as! GameObject

            if go.chunkCoord != nil {
                let event = Event(type: .gameObjectMoveToBelongField,
                                  udata: nil,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            }

            if go.invCoord != nil {
                let event = Event(type: .gameObjectMoveToBelongInv,
                                  udata: nil,
                                  sender: go)
                EventManager.default.enqueue(event)

                return
            }

            let event = Event(type: .gameObjectTake,
                    udata: nil,
                    sender: go)
            EventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectMoveToBelongField
            let go = event.sender as! GameObject
            let characterCoord = scene.character.data.chunkCoord.coord

            if go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
                go.removeFromParent()
                    scene.chunkContainer.add(go)
                    scene.accessibleGOTracker.add(go)

                return
            }

            let event = Event(type: .gameObjectTake,
                    udata: nil,
                    sender: go)
            EventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectMoveToBelongInv
            let go = event.sender as! GameObject

            guard !scene.invContainer.isValid(go.invCoord!) else {
                go.removeFromParent()
                    scene.invContainer.add(go)

                return
            }

            let event = Event(type: .gameObjectTake,
                    udata: nil,
                    sender: go)
            EventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectTake
            let go = event.sender as! GameObject
            let characterInv = scene.invContainer.characterInv

            if let index = characterInv.emptyIndex {
                let newInvCoord = InventoryCoordinate(characterInv.id, index)
                go.data.set(invCoord: newInvCoord)
                go.removeFromParent()
                characterInv.add(go)

                return
            }

            go.data.set(chunkCoord: scene.character.data.chunkCoord)
            go.removeFromParent()
            scene.chunkContainer.chunks[Direction9.origin].add(go)
            scene.accessibleGOTracker.add(go)
        },

        { scene, event in // gameObjectMoveToUI
            let go = event.sender as! GameObject

            go.move(toParent: scene.ui)
        },

        { scene, event in // gameObjectInteract
            let go = event.sender as! GameObject

            print("interact go")
        },
        { scene, event in // gameObjectInteractToGO
            let go = event.sender as! GameObject
            let targetGO = event.udata as! GameObject

            print("interact go to go")
        },
        { scene, event in // accessibleGOTrackerAdd
            let go = event.sender as! GameObject

            scene.accessibleGOTracker.add(go)
        },

        { scene, event in // accessibleGOTrackerRemove
            let go = event.sender as! GameObject

            scene.accessibleGOTracker.remove(go)
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

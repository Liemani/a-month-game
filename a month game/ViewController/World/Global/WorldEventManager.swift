//
//  SceneEvent.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

enum WorldEventType: Int, CaseIterable, EventType {

    var manager: EventManager { WorldEventManager.default }
    var handler: (WorldScene, Event) -> Void { WorldEventType.eventHandlers[self] }

    case menuButton
    case menuExitButton
    
    case characterTouchBegan
    case gameObjectTouchBegan
    case gameObjectMoveTouchBegan

    case gameObjectMoveTouchEnded
    case gameObjectMoveTouchEndedAtAccessibleField
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
        { scene, event in // menuButton
            scene.munuWindow.reveal()
        },

        { scene, event in // menuExitButton
            NotificationCenter.default.post(name: .requestPresentPortalSceneViewController, object: nil)
        },

        { scene, event in // characterTouchBegan
            let handler = CharacterMoveTouchEventHandler(
                recognizer: event.sender as! UIGestureRecognizer,
                view: scene.view!,
                character: scene.character)
            if GestureEventHandlerManager.default.add(handler) {
                handler.began()
            }
        },

        { scene, event in // gameObjectTouchBegan
            print("Under construction")
//            let handler = GameObjectTouchEventHandler(
//                touch: event.udata as! UITouch,
//                go: event.sender as! GameObject)
//            if GestureEventHandlerManager.default.add(handler) {
//                handler.began()
//            }
        },

        { scene, event in // gameObjectMoveTouchBegan
            print("Under construction")
//            let handler = GameObjectMoveTouchEventHandler(
//                touch: event.udata as! UITouch,
//                go: event.sender as! GameObject)
//            if GestureEventHandlerManager.default.add(handler) {
//                handler.began()
//            }
        },

        { scene, event in // gameObjectMoveTouchEnded
            let go = event.sender as! GameObject
            let touch = event.udata as! UITouch

            let characterChunkCoord = scene.character.chunkCoord

            if let touchedTileChunkCoord = scene.chunkContainer.coordAtLocation(of: touch),
               touchedTileChunkCoord.coord.isAdjacent(to: characterChunkCoord.coord) {
                let event = Event(type: WorldEventType.gameObjectMoveTouchEndedAtAccessibleField,
                                  udata: touchedTileChunkCoord,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }

            if let touchedInvCoord = scene.invContainer.coordAtLocation(of: touch) {
                let event = Event(type: WorldEventType.gameObjectMoveTouchEndedAtInv,
                                  udata: touchedInvCoord,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }

            let event = Event(type: WorldEventType.gameObjectMoveToBelong,
                              udata: nil,
                              sender: go)
            WorldEventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectMoveTouchEndedAtAccessibleField
            let go = event.sender as! GameObject
            let touchedTileChunkCoord = event.udata as! ChunkCoordinate

            if let targetGO = scene.chunkContainer.item(at: touchedTileChunkCoord) {
                let event = Event(type: WorldEventType.gameObjectInteractToGO,
                                  udata: targetGO,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            } else {
                go.data.set(chunkCoord: touchedTileChunkCoord)

                let event = Event(type: WorldEventType.gameObjectMoveToBelongField,
                                  udata: nil,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }
        },

        { scene, event in // gameObjectMoveTouchEndedAtInv
            let go = event.sender as! GameObject
            let invCoord = event.udata as! InventoryCoordinate

            if let targetGO = scene.invContainer.item(at: invCoord) {
                let event = Event(type: WorldEventType.gameObjectInteractToGO,
                                  udata: targetGO,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            } else {
                go.data.set(invCoord: invCoord)

                let event = Event(type: WorldEventType.gameObjectMoveToBelongInv,
                                  udata: nil,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }
        },

        { scene, event in // gameObjectMoveToBelong
            let go = event.sender as! GameObject

            if go.chunkCoord != nil {
                let event = Event(type: WorldEventType.gameObjectMoveToBelongField,
                                  udata: nil,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }

            if go.invCoord != nil {
                let event = Event(type: WorldEventType.gameObjectMoveToBelongInv,
                                  udata: nil,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }

            let event = Event(type: WorldEventType.gameObjectTake,
                    udata: nil,
                    sender: go)
            WorldEventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectMoveToBelongField
            let go = event.sender as! GameObject
            let characterCoord = scene.character.data.chunkCoord.coord

            if go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
                go.lmiRemoveFromParent()
                scene.chunkContainer.add(go)
                scene.accessibleGOTracker.add(go)

                return
            }

            let event = Event(type: WorldEventType.gameObjectTake,
                    udata: nil,
                    sender: go)
            WorldEventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectMoveToBelongInv
            let go = event.sender as! GameObject

            guard !scene.invContainer.isValid(go.invCoord!) else {
                go.lmiRemoveFromParent()
                    scene.invContainer.add(go)

                return
            }

            let event = Event(type: WorldEventType.gameObjectTake,
                    udata: nil,
                    sender: go)
            WorldEventManager.default.enqueue(event)
        },

        { scene, event in // gameObjectTake
            let go = event.sender as! GameObject
            let characterInv = scene.invContainer.characterInv

            if let index = characterInv.emptyIndex {
                let newInvCoord = InventoryCoordinate(characterInv.id, index)
                go.data.set(invCoord: newInvCoord)
                go.lmiRemoveFromParent()
                characterInv.add(go)

                return
            }

            go.data.set(chunkCoord: scene.character.data.chunkCoord)
            go.lmiRemoveFromParent()
            scene.chunkContainer.chunks[Direction9.origin].add(go)
            scene.accessibleGOTracker.add(go)
        },

        { scene, event in // gameObjectMoveToUI
            let go = event.sender as! GameObject

            go.lmiMove(toParent: scene.ui)
        },

        { scene, event in // gameObjectInteract
            let go = event.sender as! GameObject

            print("interact go")
        },

        { scene, event in // gameObjectInteractToGO
            let go = event.sender as! GameObject
            let targetGO = event.udata as! GameObject

            if targetGO.type.isTile {
                let tileChunkCoord = targetGO.chunkCoord!
                go.data.set(chunkCoord: tileChunkCoord)

                let event = Event(type: WorldEventType.gameObjectMoveToBelongField,
                                  udata: nil,
                                  sender: go)
                WorldEventManager.default.enqueue(event)

                return
            }

//            if no interaction
            let event = Event(type: WorldEventType.gameObjectMoveToBelong,
                              udata: nil,
                              sender: go)
            WorldEventManager.default.enqueue(event)
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

}

class WorldEventManager: EventManager {

    private static var _default: WorldEventManager?
    static var `default`: WorldEventManager { self._default! }

    static func set() { self._default = WorldEventManager() }
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

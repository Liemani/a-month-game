//
//  GameObjectMoveTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/23.
//

import Foundation
import SpriteKit

class GameObjectMoveTouchEventHandler: TouchEventHandler {

    var touch: UITouch

    private let go: GameObject

    init(touch: UITouch, go: GameObject) {
        self.touch = touch
        self.go = go
    }

    func touchBegan() {
        if self.go.chunkCoord != nil && !self.go.type.isPickable {
            self.complete()
            return
        }

        self.go.activate()

        let event = Event(type: .gameObjectMoveToUI,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event)

        let event2 = Event(type: .accessibleGOTrackerRemove,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event2)

        self.touchMoved()
    }

    func touchMoved() {
        self.go.setPositionToLocation(of: touch)
    }

    func touchEnded() {
        let event = Event(type: .gameObjectMoveTouchEnded,
                               udata: self.touch,
                               sender: self.go)
        EventManager.default.enqueue(event)

        self.complete()

//        guard self.touchResponderManager.contains(from: touch) else {
//            return
//        }
//
//        switch self.parent {
//        case is FieldNode:
//            self.resetTouch(touch)
//            self.interact()
//        case is InventoryCell:
//            self.resetTouch(touch)
//            self.interact()
//        case is ThirdHand:
//            if let touchedCell = self.worldScene.inventory.cellAtLocation(of: touch) {
//                if touchedCell.isEmpty {
//                    touchedCell.moveGOMO(self)
//                    self.resetTouch(touch)
//                    return
//                } else {
//                    self.touchCancelled(touch)
//                    return
//                }
//            }
//
//            let characterTC = self.worldScene.worldViewController.character.tileCoord
//            let touchedTC = Coordinate<Int>(from: touch.location(in: self.worldScene.field))
//            if touchedTC.isAdjacent(to: characterTC) {
//                let goAtLocationOfTouch = self.worldScene.interactionZone.goAtLocation(of: touch)
//                if goAtLocationOfTouch == nil {
//                    let goCoord = GameObjectCoordinate(containerType: .field, coordinate: touchedTC.coord)
//                    self.worldScene.moveGOMO(from: self, to: goCoord)
//                    self.resetTouch(touch)
//                } else {
//                    self.touchCancelled(touch)
//                }
//            } else {
//                self.touchCancelled(touch)
//            }
//        case is CraftCell:
//            self.touchCancelled(touch)
//        default: break
//        }
    }

    func touchCancelled() {
        #warning("in progress")
        let event = Event(type: .gameObjectAddToChunk,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event)

        print("move go to it's original position if fail drop current tile")

        self.complete()
    }

    func complete() {
        self.go.deactivate()
        TouchEventHandlerManager.default.remove(from: self.touch)
    }

}

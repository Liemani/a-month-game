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
        guard self.go.type.isPickable else {
            TouchEventHandlerManager.default.remove(from: touch)
            return
        }

        self.go.activate()

        self.touchMoved()

        let event = WorldEvent(type: .accessableGOTrackerRemove,
                               udata: self.touch,
                               sender: self.go)
        WorldEventManager.default.enqueue(event)
    }

    func touchMoved() {
        self.go.setPositionToLocation(of: touch)

//        switch self.parent {
//        case is FieldNode:
//            if !self.isPickable {
//                self.touchCancelled(touch)
//            } else {
//                let coord = Coordinate<Int>(0, 0)
//                self.worldScene.thirdHand.moveGOMO(from: self, to: coord)
//            }
//        case is InventoryCell:
//            let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
//            self.worldScene.moveGOMO(from: self, to: goCoord)
//        case is CraftCell:
//            if self.type == .none {
//                self.touchCancelled(touch)
//            } else {
//                self.craftWindow.refill(self)
//            }
//        default: break
//        }
    }

    func touchEnded() {
        self.go.deactivate()

        TouchEventHandlerManager.default.remove(from: self.touch)
        let event = WorldEvent(type: .gameObjectMoveTouchEnded,
                udata: self.touch,
                sender: self.go)
        WorldEventManager.default.enqueue(event)

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
        self.go.setUpPosition()

        print("move go to it's original position if fail drop current tile")

        self.go.deactivate()
    }

}

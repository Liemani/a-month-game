//
//  GameObjectTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class GameObjectTouchHandler {

    var touch: UITouch!
    private var go: GameObject!
    private var activatedGO: GameObject?

}

extension GameObjectTouchHandler {

    func began(touch: UITouch, go: GameObject) {
        self.touch = touch
        self.go = go

        self.go.activate()
    }

    func moved() {
        if self.go.isBeing(touched: touch) {
            self.go.activate()
        } else {
            self.go.deactivate()
        }
    }

    func ended() {
        guard self.go.isBeing(touched: touch) else {
            self.complete()

            return
        }

        if let activatedGO = self.activatedGO {
            if self.go.isOnField {
                let event = Event(type: WorldEventType.gameObjectInteractToGO,
                                  udata: self.go,
                                  sender: activatedGO)
                WorldEventManager.default.enqueue(event)
            } else {
                if self.go != activatedGO {
                    let event = Event(type: WorldEventType.gameObjectInteractToGO,
                                      udata: self.go,
                                      sender: activatedGO)
                    WorldEventManager.default.enqueue(event)
                }
            }

            activatedGO.deactivate()
            self.activatedGO = nil
            self.complete()

            return
        }

        // no activatedGO
        guard !self.go.isOnField else {
            if self.go.type.isPickable {
                let event = Event(type: WorldEventType.gameObjectTake,
                                  udata: nil,
                                  sender: self.go!)
                WorldEventManager.default.enqueue(event)
            } else {
                let event = Event(type: WorldEventType.gameObjectInteract,
                                  udata: nil,
                                  sender: self.go!)
                WorldEventManager.default.enqueue(event)
            }

            self.complete()

            return
        }

        self.activatedGO = self.go

        self.complete()
        self.go.activate()

        return
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        self.go.deactivate()
        self.touch = nil
    }

}

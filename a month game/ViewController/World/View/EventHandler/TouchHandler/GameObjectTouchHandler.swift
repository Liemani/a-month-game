//
//  GameObjectTouchHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class GameObjectTouchHandler {

    var touch: UITouch!
    private var go: GameObject!

}

extension GameObjectTouchHandler: TouchEventHandler {

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

        if let activatedGO = TouchHandlerContainer.default.activatedGO {
            if self.go.isOnField {
                GameObjectManager.default.interactToGO(activatedGO, to: go)
            } else {
                if self.go != activatedGO {
                    GameObjectManager.default.interactToGO(activatedGO, to: go)
                }
            }

            activatedGO.deactivate()
            TouchHandlerContainer.default.activatedGO = nil
            self.complete()

            return
        }

        // no activatedGO
        guard !self.go.isOnField else {
            if self.go.type.isPickable {
                GameObjectManager.default.take(go)
            } else {
                GameObjectManager.default.interact(go)
            }

            self.complete()

            return
        }

        TouchHandlerContainer.default.activatedGO = self.go

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

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
        self.endedProcess()

        self.complete()
    }

    private func endedProcess() {
        guard self.go.isBeing(touched: touch) else {
            self.go.deactivate()

            return
        }

        if let activatedGO = TouchHandlerContainer.default.activatedGO {
            activatedGO.deactivate()
            go.deactivate()

            if activatedGO == go {
                GameObjectManager.default.interact(go)
            } else {
                GameObjectManager.default.interactToGO(activatedGO, to: go)
            }

            TouchHandlerContainer.default.activatedGO = nil

            return
        }

        // no activatedGO
        if self.go.isOnField
            && !self.go.type.isPickable {
            self.go.deactivate()
            GameObjectManager.default.interact(go)

            return
        }

        TouchHandlerContainer.default.activatedGO = self.go

        return
    }

    func cancelled() {
        self.go.deactivate()

        self.complete()
    }

    func complete() {
        self.touch = nil
    }

}

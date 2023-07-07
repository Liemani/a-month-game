//
//  GameObjectTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class GameObjectTouchLogic {

    let touch: UITouch
    private let go: GameObject

    init(touch: UITouch, go: GameObject) {
        self.touch = touch
        self.go = go
    }

}

extension GameObjectTouchLogic: TouchLogic {

    func began() {
        self.go.activate()
    }

    func moved() {
        if self.go.isBeing(touched: self.touch) {
            self.go.activate()
        } else {
            self.go.deactivate()
        }
    }

    func ended() {
        guard self.go.isBeing(touched: self.touch) else {
            self.go.deactivate()

            return
        }

        if let activatedGO = LogicContainer.default.touch.activatedGO {
            activatedGO.deactivate()
            go.deactivate()

            if activatedGO == go {
                LogicContainer.default.sceneLow.interact(go)
            } else {
                LogicContainer.default.sceneLow.interactToGO(activatedGO, to: go)
            }

            LogicContainer.default.touch.activatedGO = nil

            return
        }

        // no activatedGO
        if self.go.isOnField
            && !self.go.type.isPickable {
            self.go.deactivate()
            LogicContainer.default.sceneLow.interact(go)

            return
        }

        LogicContainer.default.touch.activatedGO = self.go

        return
    }

    func cancelled() {
        self.go.deactivate()
    }

}

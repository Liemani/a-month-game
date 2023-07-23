//
//  GameObjectTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class GameObjectTapLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }
    private let go: GameObject

    init(touch: UITouch, go: GameObject) {
        self.go = go

        super.init()

        self.touches.append(touch)
    }

    override func began() {
        self.go.activate()
    }

    override func moved() {
        if self.go.isBeing(touched: self.touch) {
            self.go.activate()
        } else {
            self.go.deactivate()
        }
    }

    override func ended() {
        var go = self.go

        guard go.isBeing(touched: self.touch) else {
            go.deactivate()

            return
        }

#if DEBUG
        print(go.debugDescription)
#endif

        if go.type.isFloor {
            go.deactivate()
            go = Services.default.chunkContainer.items(at: go.chunkCoord!)!.last!
            go.activate()
        }

        if let activatedGO = TouchServices.default.activatedGO {
            activatedGO.deactivate()
            go.deactivate()

            if activatedGO == go {
                go.interact()
            } else {
                activatedGO.interact(to: go)
            }

            TouchServices.default.activatedGO = nil

            return
        }

        // no activatedGO
        if go.isOnField
            && !go.type.isMovable {
            go.interact()
            go.deactivate()

            return
        }

        TouchServices.default.activatedGO = go
    }

    override func cancelled() {
        self.go.deactivate()
    }

}

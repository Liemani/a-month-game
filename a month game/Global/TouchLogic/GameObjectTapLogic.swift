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
        guard self.go.isBeing(touched: self.touch) else {
            self.go.deactivate()

            return
        }

#if DEBUG
        print(go.debugDescription)
#endif

        var go = go

        if go.type.isTile {
            go = Logics.default.chunkContainer.items(at: go.chunkCoord!)!.last!
        }

        if let activatedGO = TouchLogics.default.activatedGO {
            activatedGO.deactivate()
            go.deactivate()

            if activatedGO == go {
                Logics.default.go.interact(go)
            } else {
                Logics.default.go.interactToGO(activatedGO, to: go)
            }

            TouchLogics.default.activatedGO = nil

            return
        }

        // no activatedGO
        if go.isOnField
            && !go.type.isPickable {
            go.deactivate()
            Logics.default.go.interact(go)

            return
        }

        TouchLogics.default.activatedGO = self.go

        return
    }

    override func cancelled() {
        self.go.deactivate()
    }

}

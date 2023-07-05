//
//  CraftTouchHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation
import SpriteKit

class CraftTouchHandler {

    let invContainer: InventoryContainer

    var touch: UITouch!
    var craftObject: CraftObject!

    init(invContainer: InventoryContainer) {
        self.invContainer = invContainer
    }

}

extension CraftTouchHandler: TouchEventHandler {

    func began(touch: UITouch, craftObject: CraftObject) {
        self.touch = touch
        self.craftObject = craftObject

        craftObject.activate()
    }

    func moved() {
        if self.craftObject.isBeing(touched: self.touch) {
            self.craftObject.activate()
        } else {
            self.craftObject.deactivate()
        }
    }

    func ended() {
        guard self.craftObject.isBeing(touched: self.touch) else {
            self.complete()

            return
        }

        for go in self.craftObject.consumeTargets {
            GameObjectManager.default.removeFromParent(go)
            go.delete()
        }

        let emptyIndex = self.invContainer.emptyCoord!
        GameObjectManager.default.new(type: self.craftObject.goType,
                                      variant: 0,
                                      invCoord: emptyIndex)

        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        craftObject.deactivate()
        self.touch = nil
    }

}

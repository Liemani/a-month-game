//
//  InventoryTouchHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class InventoryTouchHandler {

    var touch: UITouch!
    var touchedCell: InventoryCell!

}

extension InventoryTouchHandler: TouchEventHandler {

    func began(touch: UITouch, touchedCell: InventoryCell) {
        self.touch = touch
        self.touchedCell = touchedCell

        touchedCell.activate()
    }

    func moved() {
        if self.touchedCell.isBeing(touched: self.touch) {
            self.touchedCell.activate()
        } else {
            self.touchedCell.deactivate()
        }
    }

    func ended() {
        guard self.touchedCell.isBeing(touched: self.touch) else {
            self.complete()

            return
        }

        if let activatedGO = TouchHandlerContainer.default.activatedGO {
            GameObjectManager.default.removeFromParent(activatedGO)
            activatedGO.data.set(coord: self.touchedCell.invCoord)

            GameObjectManager.default.addToBelongInv(activatedGO)

            activatedGO.deactivate()
            TouchHandlerContainer.default.activatedGO = nil
            self.complete()

            return
        }

        self.complete()

        return
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        touchedCell.deactivate()
        self.touch = nil
    }

}

//
//  InventoryTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class InventoryTouchLogic {

    private let logic: Logic

    var touch: UITouch { self.logic.touch }

    init() {
        self.logic = Logic()
    }

}

// MARK: - logic
extension InventoryTouchLogic {

    private class Logic: TouchEventHandler {

        var touch: UITouch!
        var touchedCell: InventoryCell!

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
                return
            }

            if let activatedGO = LogicContainer.default.touch.activatedGO,
               touchedCell.isEmpty {
                LogicContainer.default.scene.move(activatedGO,
                                                  to: self.touchedCell.invCoord)
            }

            LogicContainer.default.touch.freeActivatedGO()
        }

        func cancelled() {
        }

        func complete() {
            self.touch = nil
            self.touchedCell.deactivate()
        }

    }

}

// MARK: - facade
extension InventoryTouchLogic: TouchEventHandler {

    func began(touch: UITouch, touchedCell: InventoryCell) {
        self.logic.began(touch: touch, touchedCell: touchedCell)
    }

    func moved() {
        self.logic.moved()
    }

    func ended() {
        self.logic.ended()
        self.logic.complete()
    }

    func cancelled() {
        self.logic.cancelled()
        self.logic.complete()
    }

}

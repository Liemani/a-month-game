//
//  InventoryTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class InventoryTouchLogic {

    var touch: UITouch { self.logic.touch }
    private let logic: Logic

    init(touch: UITouch, cell: InventoryCell) {
        self.logic = Logic(touch: touch, cell: cell)
    }

}

// MARK: - logic
fileprivate class Logic: TouchLogic {

    let touch: UITouch
    private let cell: InventoryCell

    init(touch: UITouch, cell: InventoryCell) {
        self.touch = touch
        self.cell = cell
    }

    func began() {
        self.cell.activate()
    }

    func moved() {
        if self.cell.isBeing(touched: self.touch) {
            self.cell.activate()
        } else {
            self.cell.deactivate()
        }
    }

    func ended() {
        guard self.cell.isBeing(touched: self.touch) else {
            return
        }

        if let activatedGO = LogicContainer.default.touch.activatedGO {
            if self.cell.isEmpty {
                LogicContainer.default.touch.freeActivatedGO()
                LogicContainer.default.scene.move(activatedGO, to: self.cell.invCoord)
            } else {
                LogicContainer.default.touch.freeActivatedGO()
                LogicContainer.default.go.interactToGO(activatedGO, to: cell.go!)
            }
        }
    }

    func cancelled() {
    }

    func complete() {
        self.cell.deactivate()
    }

}

// MARK: - facade
extension InventoryTouchLogic: TouchLogic {

    func began() {
        self.logic.began()
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

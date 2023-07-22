//
//  InventoryTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class InventoryTapLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }

    private let cell: InventoryCell

    init(touch: UITouch, cell: InventoryCell) {
        self.cell = cell

        super.init()

        self.touches.append(touch)
    }

    // MARK: - logic
    func logicBegan() {
        self.cell.activate()
    }

    func logicMoved() {
        if self.cell.isBeing(touched: self.touch) {
            self.cell.activate()
        } else {
            self.cell.deactivate()
        }
    }

    func logicEnded() {
        guard self.cell.isBeing(touched: self.touch) else {
            return
        }

        if let activatedGO = TouchLogics.default.activatedGO {
            if self.cell.isEmpty {
                TouchLogics.default.freeActivatedGO()
                if activatedGO.isInInv || activatedGO.type.isPickable {
                    activatedGO.move(to: self.cell.invCoord)
                }
            } else {
                TouchLogics.default.freeActivatedGO()
                activatedGO.interact(to: cell.go!)
            }
        }
    }

    func logicCancelled() {
    }

    // MARK: - facade
    override func began() {
        self.logicBegan()
    }

    override func moved() {
        self.logicMoved()
    }

    override func ended() {
        self.logicEnded()
        self.complete()
    }

    override func cancelled() {
        self.logicCancelled()
        self.complete()
    }

    func complete() {
        self.cell.deactivate()
    }

}


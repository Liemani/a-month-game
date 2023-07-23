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

    override func began() {
        self.cell.activate()
    }

    override func moved() {
        if self.cell.isBeing(touched: self.touch) {
            self.cell.activate()
        } else {
            self.cell.deactivate()
        }
    }

    override func ended() {
        guard self.cell.isBeing(touched: self.touch) else {
            self.cell.deactivate()
            return
        }

        if let activatedGO = TouchServices.default.activatedGO {
            if self.cell.isEmpty {
                TouchServices.default.freeActivatedGO()
                if activatedGO.isInInv || activatedGO.type.isPickable {
                    activatedGO.move(to: self.cell.invCoord)
                }
            } else {
                TouchServices.default.freeActivatedGO()
                activatedGO.interact(to: cell.go!)
            }

            self.cell.deactivate()

            return
        }

        if let go = self.cell.go {
            TouchServices.default.activatedGO = go
            return
        }

        self.cell.deactivate()
    }

    override func cancelled() {
        self.cell.deactivate()
    }

}


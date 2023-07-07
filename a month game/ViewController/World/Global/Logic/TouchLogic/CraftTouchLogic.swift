//
//  CraftTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation
import SpriteKit

class CraftTouchLogic {

    let touch: UITouch
    private let craftObject: CraftObject

    init(touch: UITouch, craftObject: CraftObject) {
        self.touch = touch
        self.craftObject = craftObject
    }

}

extension CraftTouchLogic: TouchLogic {

    func began() {
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
            LogicContainer.default.sceneLow.removeFromParent(go)
            go.delete()
        }

        let emptyCoord = LogicContainer.default.invContainer.emptyCoord!
        LogicContainer.default.sceneLow.new(type: self.craftObject.goType,
                                            coord: emptyCoord)

        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        craftObject.deactivate()
    }

}

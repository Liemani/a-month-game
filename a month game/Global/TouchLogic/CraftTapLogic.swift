//
//  CraftTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/02.
//

import Foundation
import SpriteKit

class CraftTapLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }

    private let craftObject: CraftObject

    init(touch: UITouch, craftObject: CraftObject) {
        self.craftObject = craftObject

        super.init()

        self.touches.append(touch)
    }

    override func began() {
        craftObject.activate()
    }

    override func moved() {
        if self.craftObject.isBeing(touched: self.touch) {
            self.craftObject.activate()
        } else {
            self.craftObject.deactivate()
        }
    }

    override func ended() {
        guard self.craftObject.isBeing(touched: self.touch) else {
            self.complete()

            return
        }

        let consumeTargets = self.craftObject.consumeTargets
        var sum = 0.0

        for go in consumeTargets {
            Logics.default.go.remove(go)
            sum += go.quality
        }

        let emptyCoord = Logics.default.invContainer.emptyCoord!
        Logics.default.go.new(type: self.craftObject.goType,
                                      quality: sum / Double(consumeTargets.count),
                                      coord: emptyCoord)

        self.complete()
    }

    override func cancelled() {
        self.complete()
    }

    func complete() {
        craftObject.deactivate()
    }

}

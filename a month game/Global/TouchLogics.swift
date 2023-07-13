//
//  TouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

class TouchLogic {

    var touches: [UITouch]

    init() {
        self.touches = []
    }

    func began() {
    }

    func moved() {
    }

    func ended() {
    }

    func cancelled() {
    }

}

class TouchLogics {

    static var `default` = TouchLogics()

    private var logics: [UITouch: TouchLogic]
    var activatedGO: GameObject?

    init() {
        self.logics = [:]
    }

    func add(_ logic: TouchLogic) {
        for touch in logic.touches {
            self.logics[touch] = logic
        }
    }

    func began(_ touch: UITouch) {
        self.logics[touch]!.began()
    }

    func moved(_ touch: UITouch) {
        guard let logic = self.logics[touch] else {
            return
        }

        logic.moved()
    }

    func ended(_ touch: UITouch) {
        guard let logic = self.logics[touch] else {
            return
        }

        logic.ended()
        self.complete(touch)
    }

    func cancelled(_ touch: UITouch) {
        guard let logic = self.logics[touch] else {
            return
        }

        logic.cancelled()
        self.complete(touch)
    }

    func complete(_ touch: UITouch) {
        self.logics[touch] = nil
    }

    func freeActivatedGO() {
        self.activatedGO!.deactivate()
        self.activatedGO = nil
    }

}

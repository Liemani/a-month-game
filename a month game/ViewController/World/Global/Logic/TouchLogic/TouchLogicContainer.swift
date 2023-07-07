//
//  TouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/01.
//

import Foundation
import SpriteKit

protocol TouchLogic {

    var touch: UITouch { get }

    func began()
    func moved()
    func ended()
    func cancelled()

}

class TouchLogicContainer {

    private var logics: [UITouch: TouchLogic]
    var activatedGO: GameObject?

    init() {
        self.logics = [:]
    }

    func add(_ logic: TouchLogic) {
        self.logics[logic.touch] = logic
    }

    func began(_ touch: UITouch) {
        self.logics[touch]!.began()
    }

    func moved(_ touch: UITouch) {
        self.logics[touch]!.moved()
    }

    func ended(_ touch: UITouch) {
        self.logics[touch]!.ended()
        self.complete(touch)
    }

    func cancelled(_ touch: UITouch) {
        self.logics[touch]!.cancelled()
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

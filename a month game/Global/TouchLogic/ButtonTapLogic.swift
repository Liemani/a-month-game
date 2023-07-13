//
//  ButtonTapLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class ButtonTapLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }
    private let button: Button

    init(touch: UITouch, button: Button) {
        self.button = button

        super.init()

        self.touches.append(touch)
    }

    override func began() {
        self.button.activate()
    }

    override func moved() {
        if self.button.isBeing(touched: touch) {
            self.button.activate()
        } else {
            self.button.deactivate()
        }
    }

    override func ended() {
        if self.button.isBeing(touched: touch) {
            let event = Event(type: self.button.eventType,
                              udata: nil,
                              sender: self.button)
            event.manager.enqueue(event)
        }

        self.complete()
    }

    override func cancelled() {
        self.complete()
    }

    func complete() {
        self.button.deactivate()
    }

}

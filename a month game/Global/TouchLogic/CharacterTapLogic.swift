//
//  CharacterTouchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class CharacterTapLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }
    private let character: Character

    init(touch: UITouch, character: Character) {
        self.character = character

        super.init()

        self.touches.append(touch)
    }

    override func began() {
        self.character.activate()
    }

    override func moved() {
        if self.character.isBeing(touched: self.touch) {
            self.character.activate()
        } else {
            self.character.deactivate()
        }
    }

    override func ended() {
        self.complete()
    }

    override func cancelled() {
        self.complete()
    }

    private func complete() {
        self.character.deactivate()
    }

}

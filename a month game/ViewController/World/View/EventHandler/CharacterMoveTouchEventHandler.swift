//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class CharacterMoveTouchEventHandler {

    let touch: UITouch

    private let scene: WorldScene
    private let character: Character

    private var ppTimestamp: TimeInterval!
    private var pTimestamp: TimeInterval!
    private var ppLocation: CGPoint?

    // MARK: - init
    init(touch: UITouch, worldScene: WorldScene, character: Character) {
        self.touch = touch
        self.scene = worldScene
        self.character = character
    }

}

extension CharacterMoveTouchEventHandler: TouchEventHandler {

    func touchBegan() {
        self.pTimestamp = self.touch.timestamp
        self.character.velocityVector = CGVector()
    }

    func touchMoved() {
        let pPoint = self.touch.previousLocation(in: self.scene)
        let currentPoint = self.touch.location(in: self.scene)
        let difference = currentPoint - pPoint

        self.character.position -= difference

        self.ppTimestamp = self.pTimestamp
        self.pTimestamp = self.touch.timestamp
        self.ppLocation = pPoint
    }

    func touchEnded() {
        self.setCharacterVelocity()
    }

    private func setCharacterVelocity() {
        guard let ppLocation = self.ppLocation else {
            return
        }

        let pLocation = self.touch.previousLocation(in: self.scene)
        let timeInterval = self.pTimestamp - self.ppTimestamp

        self.character.velocityVector = (-(pLocation - ppLocation) / timeInterval).vector

        self.complete()
    }

    func touchCancelled() {
        self.complete()
    }

    func complete() {
        TouchEventHandlerManager.default.remove(from: self.touch)
    }

}

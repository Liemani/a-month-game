//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class CharacterMoveTouchBeganEventHandler {

    let touch: UITouch

    private let scene: WorldScene
    private let character: Character

    private var previousPreviousTimestamp: TimeInterval!
    private var previousTimestamp: TimeInterval!
    private var previousPreviousLocation: CGPoint?

    // MARK: - init
    init(touch: UITouch, worldScene: WorldScene, character: Character) {
        self.touch = touch
        self.scene = worldScene
        self.character = character
    }

}

extension CharacterMoveTouchBeganEventHandler: TouchEventHandler {

    func touchBegan() {
        self.previousTimestamp = self.touch.timestamp
        self.character.velocityVector = CGVector()
    }

    func touchMoved() {
        let previousPoint = self.touch.previousLocation(in: self.scene)
        let currentPoint = self.touch.location(in: self.scene)
        let difference = currentPoint - previousPoint

        self.character.position -= difference

        self.previousPreviousTimestamp = self.previousTimestamp
        self.previousTimestamp = self.touch.timestamp
        self.previousPreviousLocation = previousPoint
    }

    func touchEnded() {
        self.setVelocityVector()
    }

    private func setVelocityVector() {
        guard let previousPreviousLocation = self.previousPreviousLocation else {
            return
        }

        let previousLocation = self.touch.previousLocation(in: self.scene)
        let timeInterval = self.previousTimestamp - self.previousPreviousTimestamp

        self.character.velocityVector = (-(previousLocation - previousPreviousLocation) / timeInterval).toVector()
    }

    func touchCancelled() { }

}

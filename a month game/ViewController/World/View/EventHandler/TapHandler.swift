//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class TapHandler {

    var touch: LMITouch?
    var touches: [LMITouch] {
        if let touch = self.touch {
            return [touch]
        } else {
            return []
        }
    }

    private let scene: WorldScene
    private let character: Character

    private var pPoint: CGPoint!
    private var cPoint: CGPoint!

    // MARK: - init
    init(scene: WorldScene, character: Character) {
        self.scene = scene
        self.character = character
    }

}

extension TapHandler: TouchHandler {

    func discriminate(touch: LMITouch) -> Bool { return true }

    func removeFromTracking(touch: LMITouch) {

    }

    func began(touches: [LMITouch]) {
        let touch = touches[0]
        self.touch = touch
        self.character.velocityVector = CGVector()
        self.cPoint = touch.touch.location(in: self.scene)
    }

    func moved() {
        self.pPoint = self.cPoint
        self.cPoint = self.touch!.touch.location(in: self.scene)
        let delta = self.cPoint - self.pPoint

        self.character.position -= delta
    }

    func ended() {
        self.setCharacterVelocity()
    }

    private func setCharacterVelocity() {
        guard self.pPoint != nil else { return }

        let timeInterval = self.scene.timeInterval

        self.character.velocityVector = (-(self.cPoint - self.pPoint) / timeInterval).vector

        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        self.touch = nil
    }

}

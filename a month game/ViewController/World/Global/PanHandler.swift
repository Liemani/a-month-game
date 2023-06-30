//
//  PanHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PanHandler {

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

    init(scene: WorldScene, character: Character) {
        self.scene = scene
        self.character = character
    }

}

extension PanHandler: TouchHandler {

    func discriminate(touches: [LMITouch]) -> Bool {
        guard touches[0].possible.contains(.pan) else {
            return false
        }

        let currentTime = CACurrentMediaTime()

        if self.touch != nil
            || currentTime - touches[0].bTime > 1.0 {
            touches[0].possible.remove(.pan)
            return false
        }

        return touches[0].velocity(in: self.scene) >= Constant.panThreshold
    }

    func began(touches: [LMITouch]) {
        print("pan began")

        self.touch = touches[0]
        self.character.velocityVector = CGVector()
        self.cPoint = self.touch!.location(in: self.scene)
    }

    func moved() {
        self.pPoint = self.cPoint
        self.cPoint = self.touch!.location(in: self.scene)
        let delta = self.cPoint - self.pPoint

        self.character.position -= delta
    }

    func ended() {
        self.setCharacterVelocity()

        self.complete()
    }

    private func setCharacterVelocity() {
        guard self.pPoint != nil else { return }

        let timeInterval = self.scene.timeInterval

        self.character.velocityVector = (-(self.cPoint - self.pPoint) / timeInterval).vector
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        self.touch = nil
    }

}

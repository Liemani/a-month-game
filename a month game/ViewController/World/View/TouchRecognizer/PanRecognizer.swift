//
//  PanHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PanRecognizer {

    var lmiTouch: LMITouch?
    var lmiTouches: [LMITouch] {
        if let touch = self.lmiTouch {
            return [touch]
        } else {
            return []
        }
    }

    var isHandling: Bool { self.lmiTouch != nil }

    private let scene: WorldScene
    private let ui: SKNode
    private let character: Character

    private var pPoint: CGPoint!
    private var cPoint: CGPoint!

    init(scene: WorldScene, ui: SKNode, character: Character) {
        self.scene = scene
        self.ui = ui
        self.character = character
    }

}

extension PanRecognizer: TouchRecognizer {

    func discriminate(lmiTouches: [LMITouch]) -> Bool {
        let lmiTouch = lmiTouches[0]

        guard lmiTouch.possible.contains(.pan) else {
            return false
        }

        guard self.lmiTouch == nil else {
            return false
        }

//        let currentTime = CACurrentMediaTime()
//
//        guard currentTime - lmiTouch.bTime < 1.0
//            && !lmiTouch.touchedNode.isDescendant(self.ui) else {
        guard !lmiTouch.touchedNode.isDescendant(self.ui) else {
            lmiTouch.possible.remove(.pan)

            return false
        }

//        return lmiTouch.velocity(in: self.scene) >= Constant.panThreshold

        let deltaPosition = lmiTouch.touch.location(in: self.scene) - lmiTouch.bPosition

        return deltaPosition.magnitude >= Constant.tileWidth / 3.0
    }

    func began(lmiTouches: [LMITouch]) {
        let lmiTouch = lmiTouches[0]

        if self.isHandling {
            self.lmiTouch!.cancelRecognizer()
        }

        lmiTouch.setRecognizer(self)

        lmiTouch.removeLongTouchPossible()

        self.lmiTouch = lmiTouch
        self.character.velocityVector = CGVector()
        self.cPoint = self.lmiTouch!.location(in: self.scene)
    }

    func moved() {
        self.pPoint = self.cPoint
        self.cPoint = self.lmiTouch!.location(in: self.scene)
        let delta = self.cPoint - self.pPoint

        self.character.position -= delta * self.character.speedModifier
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
        self.lmiTouch = nil
    }

}

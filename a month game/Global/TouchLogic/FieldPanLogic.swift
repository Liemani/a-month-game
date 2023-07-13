//
//  FieldPanLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class FieldPanLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }

    private let scene: SKScene

    private var pPoint: CGPoint!
    private var cPoint: CGPoint!

    init(touch: UITouch, scene: SKScene) {
        self.scene = scene

        super.init()

        self.touches.append(touch)
    }

    override func began() {
        Logics.default.character.resetVelocity()
        self.cPoint = self.touch.location(in: self.scene)
    }

    override func moved() {
        self.pPoint = self.cPoint
        self.cPoint = touch.location(in: self.scene)

        let pointDelta = self.cPoint - self.pPoint
        let characterPositionDelta = -pointDelta

        Logics.default.character.applyPositionDelta(characterPositionDelta)
    }

    override func ended() {
        self.setCharacterVelocity()
    }

    private func setCharacterVelocity() {
        guard self.pPoint != nil else { return }

        let timeInterval = Logics.default.scene.timeInterval

        let velocityVector = (-(self.cPoint - self.pPoint) / timeInterval).vector

        Logics.default.character.setVelocity(velocityVector)
    }

}

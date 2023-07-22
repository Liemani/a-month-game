//
//  FieldPanLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class WorldPanLogic: TouchLogic {

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
        Services.default.character.velocityVector = CGVector.zero
        self.cPoint = self.touch.location(in: self.scene)
    }

    override func moved() {
        self.pPoint = self.cPoint
        self.cPoint = touch.location(in: self.scene)

        let pointDelta = self.cPoint - self.pPoint
        let characterPositionDelta = -pointDelta

        Services.default.character.addNPosition(characterPositionDelta)
    }

    override func ended() {
        self.setCharacterVelocity()
    }

    private func setCharacterVelocity() {
        guard self.pPoint != nil else { return }

        let timeInterval = Logics.default.scene.timeInterval

        let velocityVector = (-(self.cPoint - self.pPoint) / timeInterval).vector

        Services.default.character.velocityVector = velocityVector
    }

}

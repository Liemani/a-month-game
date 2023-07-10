//
//  Particle.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import SpriteKit

class Particle {

    static var particle: SKShapeNode!

    static func setUp() {
        let particle = SKShapeNode(rectOf: Constant.Size.particle)
        particle.strokeColor = .black
        particle.zPosition = Constant.ZPosition.particle

        particle.run(SKAction.repeatForever(SKAction.moveTo(y: Constant.defaultWidth / 2.0, duration: 0.3)))
        particle.run(SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                        SKAction.fadeOut(withDuration: 0.2),
                                        SKAction.removeFromParent()]))

        self.particle = particle
    }

    static func free() {
        self.particle = nil
    }

    static func flutter(result: TaskResultType) {
        let newParticle = self.particle.copy() as! SKShapeNode

        newParticle.fillColor = result.color

        Logics.default.character.addParticle(newParticle)
    }

}

//
//  PortalScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import SpriteKit

class PortalScene: SKScene {

    // MARK: - override
    override func didMove(to view: SKView) {
        let backgroundNode = SKSpriteNode(imageNamed: Constant.ResourceName.bgPortal)
        backgroundNode.position = Constant.screenCenter
        self.addChild(backgroundNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }

}

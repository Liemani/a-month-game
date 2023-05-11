//
//  PortalScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import SpriteKit

class PortalScene: SKScene {

    weak var portalController: PortalController!

    var uiLayer: SKNode!
    var enterButton: SKSpriteNode!
    var resetButton: SKSpriteNode!

    // MARK: - ui
    override func didMove(to view: SKView) {
        initBackground()
        initUI()
    }

    func initBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: Constant.ResourceName.bgPortal)

        backgroundNode.position = Constant.screenCenter
        backgroundNode.zPosition = -1.0

        self.addChild(backgroundNode)
    }

    func initUI() {
        let uiLayer = SKNode()

        let buttonTexture = SKTexture(imageNamed: Constant.ResourceName.button)

        self.enterButton = createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.enterButton, labelText: "Enter World", andAddTo: uiLayer)
        self.resetButton = createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.resetButton, labelText: "Reset", andAddTo: uiLayer)

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    func createLabeledSpriteNode(texture: SKTexture, in frame: CGRect, labelText: String, andAddTo parentNode: SKNode) -> SKSpriteNode{
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.position = frame.origin
        spriteNode.size = frame.size

        let labelNode = SKLabelNode(text: labelText)
        labelNode.fontSize = Constant.defaultSize / 2
        labelNode.position = CGPoint(x: 0, y: -labelNode.fontSize / 2)
        labelNode.zPosition = 1.0
        spriteNode.addChild(labelNode)

        parentNode.addChild(spriteNode)

        return spriteNode
    }

    // MARK: - touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchDown(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchUp(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchUp(touch) }
    }

    override func update(_ currentTime: TimeInterval) {
    }

}

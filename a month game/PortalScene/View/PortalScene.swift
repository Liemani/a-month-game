//
//  PortalScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import SpriteKit

class PortalScene: SKScene {

    weak var portalController: PortalSceneController!

    var uiLayer: SKNode!
    var enterButton: SKSpriteNode!
    var resetButton: SKSpriteNode!

    // MARK: - ui
    override func didMove(to view: SKView) {
        initBackground()
        initUI()
    }

    func initBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: Resource.Name.bgPortal)

        backgroundNode.position = Constant.screenUpRight
        backgroundNode.zPosition = -1.0

        self.addChild(backgroundNode)
    }

    func initUI() {
        let uiLayer = SKNode()

        let buttonTexture = SKTexture(imageNamed: Resource.Name.button)

        self.enterButton = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.enterButton, labelText: "Enter World", andAddTo: uiLayer)
        self.resetButton = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.resetButton, labelText: "Reset", andAddTo: uiLayer)

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    // MARK: - touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchDown(touch: touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchMoved(touch: touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchUp(touch: touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.portalController.touchUp(touch: touch) }
    }

    override func update(_ currentTime: TimeInterval) {
    }

}

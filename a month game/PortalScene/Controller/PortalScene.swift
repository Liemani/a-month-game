//
//  PortalScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import SpriteKit

class PortalScene: SKScene {

    weak var viewController: ViewController!

    var uiLayer: SKNode!
    var enterButton: SKSpriteNode!
    var resetButton: SKSpriteNode!

    func setUp(viewController: ViewController) {
        self.viewController = viewController

        self.size = Constant.sceneSize
        self.scaleMode = .aspectFit
    }

    // MARK: - ui
    override func didMove(to view: SKView) {
        initBackground()
        initUI()
    }

    func initBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: Constant.ResourceName.bgPortal)

        backgroundNode.position = Constant.screenUpRight
        backgroundNode.zPosition = -1.0

        self.addChild(backgroundNode)
    }

    func initUI() {
        let uiLayer = SKNode()

        let buttonTexture = SKTexture(imageNamed: Constant.ResourceName.button)

        self.enterButton = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.enterButton, labelText: "Enter World", andAddTo: uiLayer)
        self.resetButton = Helper.createLabeledSpriteNode(texture: buttonTexture, in: Constant.Frame.resetButton, labelText: "Reset", andAddTo: uiLayer)

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    func touchUp(touch: UITouch) {
        let touchPoint = touch.location(in: self.uiLayer)
        if self.enterButton.contains(touchPoint) {
            self.viewController.setWorldScene()
        }

        if self.resetButton.contains(touchPoint) {
            DiskController.default.removeWorldDirectory(ofName: Constant.defaultWorldName)
        }
    }

    // MARK: - touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches { self.touchDown(touch: touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches { self.touchMoved(touch: touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch: touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchUp(touch: touch) }
    }

    override func update(_ currentTime: TimeInterval) {
    }

}

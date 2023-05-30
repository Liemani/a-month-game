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

        let enterButton = Button(texture: buttonTexture)
        enterButton.setUp()
        enterButton.set(frame: Constant.Frame.enterButton)
        enterButton.set(text: "Enter World")
        enterButton.delegate = self
        uiLayer.addChild(enterButton)
        self.enterButton = enterButton

        let resetButton = Button(texture: buttonTexture)
        resetButton.setUp()
        resetButton.set(frame: Constant.Frame.resetButton)
        resetButton.set(text: "Reset")
        resetButton.delegate = self
        uiLayer.addChild(resetButton)
        self.resetButton = resetButton

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

}

extension PortalScene: ButtonDelegate {

    func buttonTapped(sender: Any?) {
        guard let button = sender as? Button else { return }

        if button == self.enterButton {
            self.viewController.setWorldScene()
        } else if button == self.resetButton {
            DiskController.default.removeWorldDirectory(ofName: Constant.defaultWorldName)
        }
    }

}

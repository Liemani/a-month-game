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
    var enterButton: Button!
    var resetButton: Button!
    var resetPane: ResetPane!

    func setUp(viewController: ViewController) {
        self.viewController = viewController

        self.size = Constant.sceneSize
        self.scaleMode = .aspectFit
    }

    // MARK: - ui
    override func didMove(to view: SKView) {
        addBackground()
        addUI()
    }

    func addBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: Constant.ResourceName.bgPortal)

        backgroundNode.position = Constant.screenUpRight
        backgroundNode.zPosition = Constant.ZPosition.background

        self.addChild(backgroundNode)
    }

    func addUI() {
        let uiLayer = SKNode()

        addButton(uiLayer)
        addResetPane(uiLayer)

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    func addButton(_ parent: SKNode) {
        let buttonTexture = SKTexture(imageNamed: Constant.ResourceName.button)

        let enterButton = Button(texture: buttonTexture)
        enterButton.setUp()
        enterButton.set(frame: Constant.Frame.enterButton)
        enterButton.set(text: "Enter World")
        enterButton.delegate = self
        parent.addChild(enterButton)
        self.enterButton = enterButton

        let resetButton = Button(texture: buttonTexture)
        resetButton.setUp()
        resetButton.set(frame: Constant.Frame.resetButton)
        resetButton.set(text: "Reset")
        resetButton.delegate = self
        parent.addChild(resetButton)
        self.resetButton = resetButton
    }

    func addResetPane(_ parent: SKNode) {
        let resetPane = ResetPane()
        resetPane.setUp()

        parent.addChild(resetPane)
        self.resetPane = resetPane

    }

}

extension PortalScene: ButtonDelegate {

    func buttonTapped(sender: Any?) {
        guard let button = sender as? Button else { return }

        if button == self.enterButton {
            self.viewController.setWorldScene()
        } else if button == self.resetButton {
            self.resetPane.reveal()
        }
    }

}

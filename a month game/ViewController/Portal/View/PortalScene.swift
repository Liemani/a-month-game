//
//  PortalScene.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import SpriteKit

class PortalScene: SKScene {

    var uiLayer: SKNode!
    var enterButtonNode: ButtonNode!
    var resetButtonNode: ButtonNode!
    var resetWindow: ResetWindow!

    func setUp() {
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

        addButtonNode(uiLayer)
        addResetWindow(uiLayer)

        self.addChild(uiLayer)
        self.uiLayer = uiLayer
    }

    func addButtonNode(_ parent: SKNode) {
        let buttonTexture = SKTexture(imageNamed: Constant.ResourceName.button)

        let enterButtonNode = ButtonNode(texture: buttonTexture)
        enterButtonNode.setUp()
        enterButtonNode.set(frame: Constant.Frame.enterButtonNode)
        enterButtonNode.set(text: "Enter World")
        enterButtonNode.delegate = self
        parent.addChild(enterButtonNode)
        self.enterButtonNode = enterButtonNode

        let resetButtonNode = ButtonNode(texture: buttonTexture)
        resetButtonNode.setUp()
        resetButtonNode.set(frame: Constant.Frame.resetButtonNode)
        resetButtonNode.set(text: "Reset")
        resetButtonNode.delegate = self
        parent.addChild(resetButtonNode)
        self.resetButtonNode = resetButtonNode
    }

    func addResetWindow(_ parent: SKNode) {
        let resetWindow = ResetWindow()
        resetWindow.setUp()

        parent.addChild(resetWindow)
        self.resetWindow = resetWindow

    }

}

extension PortalScene: ButtonNodeDelegate {

    func buttonTapped(sender: Any?) {
        guard let button = sender as? ButtonNode else { return }

        switch button {
        case self.enterButtonNode:
            NotificationCenter.default.post(name: .requestPresentWorldSceneViewController, object: nil)
        case self.resetButtonNode:
            self.resetWindow.reveal()
        default: break
        }
    }

}

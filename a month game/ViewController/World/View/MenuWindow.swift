//
//  MenuWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class MenuWindow: LMINode {

    override init() {
        super.init()

        // TODO: move to background(have to implement new class)
        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.munuWindow

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)
        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5
        self.addChild(background)

        let exitButtonNode = ButtonNode(imageNamed: Constant.ResourceName.button)
        exitButtonNode.setUp()
        exitButtonNode.set(frame: Constant.Frame.exitWorldButtonNode)
        exitButtonNode.set(text: "Exit World")
        exitButtonNode.delegate = self
        self.addChild(exitButtonNode)

        self.hide()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
        TouchEventHandlerManager.default.cancelAll()
    }

    func hide() {
        self.isHidden = true
        let button = self.children[1] as! ButtonNode
        if let touch = button.touch {
            button.touchCancelled(touch)
        }
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        self.hide()
    }

}

extension MenuWindow: ButtonNodeDelegate {

    func buttonTapped(sender: Any?) {
        NotificationCenter.default.post(name: .requestPresentPortalSceneViewController, object: nil)
    }

}

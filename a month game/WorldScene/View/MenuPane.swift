//
//  MenuPane.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class MenuPane: LMISpriteNode {

    func setUp() {
        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.menuPane

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)
        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5
        self.addChild(background)

        let exitButton = Button(imageNamed: Constant.ResourceName.button)
        exitButton.setUp()
        exitButton.set(frame: Constant.Frame.exitWorldButton)
        exitButton.set(text: "Exit World")
        exitButton.delegate = self
        self.addChild(exitButton)

        self.hide()
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
        self.worldScene.touchManager.cancelAll()
    }

    func hide() {
        self.isHidden = true
        let button = self.children[1] as! Button
        if let touch = button.touch {
            button.touchCancelled(touch)
        }
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        self.hide()
    }

}

extension MenuPane: ButtonDelegate {

    func buttonTapped(sender: Any?) {
        NotificationCenter.default.post(name: .requestPresentPortalViewController, object: nil)
    }

}

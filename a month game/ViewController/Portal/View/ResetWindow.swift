//
//  ResetWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class ResetWindow: LMISpriteNode {

    var portalScene: PortalScene { self.scene as! PortalScene }

    var yesButtonNode: ButtonNode!
    var noButtonNode: ButtonNode!

    func setUp() {
        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.resetWindow

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)
        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5
        self.addChild(background)

        let yesButtonNode = ButtonNode(imageNamed: Constant.ResourceName.button)
        yesButtonNode.setUp()
        yesButtonNode.set(frame: Constant.Frame.yesButtonNode)
        yesButtonNode.set(text: "Yes")
        yesButtonNode.delegate = self
        self.addChild(yesButtonNode)
        self.yesButtonNode = yesButtonNode

        let noButtonNode = ButtonNode(imageNamed: Constant.ResourceName.button)
        noButtonNode.setUp()
        noButtonNode.set(frame: Constant.Frame.noButtonNode)
        noButtonNode.set(text: "No")
        noButtonNode.delegate = self
        self.addChild(noButtonNode)
        self.noButtonNode = noButtonNode

        self.hide()
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
    }

    func hide() {
        self.isHidden = true
        if let touch = self.yesButtonNode.touch {
            yesButtonNode.touchCancelled(touch)
        }
        if let touch = self.noButtonNode.touch {
            noButtonNode.touchCancelled(touch)
        }
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        self.hide()
    }

}

extension ResetWindow: ButtonNodeDelegate {

    func buttonTapped(sender: Any?) {
        guard let button = sender as? ButtonNode else { return }

        switch button {
        case self.yesButtonNode:
            WorldDirectoryUtility.default.remove(worldName: Constant.Name.defaultWorld)
            self.hide()
        case self.noButtonNode:
            self.hide()
        default: break
        }
    }

}

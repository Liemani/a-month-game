//
//  ResetPane.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class ResetPane: LMISpriteNode {

    var portalScene: PortalScene { self.scene as! PortalScene }

    var yesButton: Button!
    var noButton: Button!

    func setUp() {
        self.isUserInteractionEnabled = true
        self.zPosition = Constant.ZPosition.resetPane

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)
        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5
        self.addChild(background)

        let yesButton = Button(imageNamed: Constant.ResourceName.button)
        yesButton.setUp()
        yesButton.set(frame: Constant.Frame.yesButton)
        yesButton.set(text: "Yes")
        yesButton.delegate = self
        self.addChild(yesButton)
        self.yesButton = yesButton

        let noButton = Button(imageNamed: Constant.ResourceName.button)
        noButton.setUp()
        noButton.set(frame: Constant.Frame.noButton)
        noButton.set(text: "No")
        noButton.delegate = self
        self.addChild(noButton)
        self.noButton = noButton

        self.hide()
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
    }

    func hide() {
        self.isHidden = true
        if let touch = self.yesButton.touch {
            yesButton.touchCancelled(touch)
        }
        if let touch = self.noButton.touch {
            noButton.touchCancelled(touch)
        }
    }

    // MARK: - touch
    override func touchBegan(_ touch: UITouch) {
        self.hide()
    }

}

extension ResetPane: ButtonDelegate {

    func buttonTapped(sender: Any?) {
        guard let button = sender as? Button else { return }

        switch button {
        case self.yesButton:
            WorldDirectoryUtility.default.remove(worldName: Constant.Name.defaultWorld)
            self.hide()
        case self.noButton:
            self.hide()
        default: break
        }
    }

}

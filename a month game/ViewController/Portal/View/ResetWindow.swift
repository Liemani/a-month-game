//
//  ResetWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class ResetWindow: SKSpriteNode {

    var yesButton: Button!
    var noButton: Button!

    func setUp() {
        self.zPosition = Constant.ZPosition.resetWindow

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)
        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5
        self.addChild(background)

        self.addButton()

        self.hide()
    }

    func addButton() {
        let texture = SKTexture(imageNamed: Constant.ResourceName.button)

        let yesButton = Button(texture: texture,
                               frame: Constant.Frame.yesButton,
                               text: "Yes",
                               eventType: PortalEventType.resetYesButton)
        self.addChild(yesButton)
        self.yesButton = yesButton

        let noButton = Button(texture: texture,
                              frame: Constant.Frame.noButton,
                              text: "No",
                              eventType: PortalEventType.resetNoButton)
        self.addChild(noButton)
        self.noButton = noButton
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
    }

    func hide() {
        self.isHidden = true
    }

}

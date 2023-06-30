//
//  MenuWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class MenuWindow: SKNode {

    override init() {
        super.init()

        // TODO: move to background(have to implement new class)
        self.zPosition = Constant.ZPosition.munuWindow

        let background = SKSpriteNode(color: .black, size: Constant.sceneSize)
        background.position = Constant.sceneCenter
        background.zPosition = -1.0
        background.alpha = 0.5
        self.addChild(background)

        let texture = SKTexture(imageNamed: Constant.ResourceName.button)
        let exitButton = Button(texture: texture,
                                frame: Constant.Frame.exitWorldButton,
                                text: "Exit World",
                                eventType: WorldEventType.menuExitButton)
        self.addChild(exitButton)

        self.hide()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
        GestureEventHandlerManager.default.cancelAll()
    }

    func hide() {
        self.isHidden = true
    }

}

extension MenuWindow {

    func touchUp(sender: Any?) {
        NotificationCenter.default.post(name: .requestPresentPortalSceneViewController, object: nil)
    }

}

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

        self.zPosition = Constant.ZPosition.menuWindow

        let backgroundButton = Button(texture: nil,
                                      frame: Constant.Frame.worldMenuBackgroundButton,
                                      text: nil,
                                      eventType: WorldEventType.menuBackgroundButton)
        backgroundButton.color = .black
        backgroundButton.zPosition = -1.0
        backgroundButton.alpha = 0.5
        backgroundButton.shouldActivated = false
        self.addChild(backgroundButton)

        self.addButton()

        self.hide()
    }

    func addButton() {
        let texture = SKTexture(imageNamed: Constant.ResourceName.button)
        let exitButton = Button(texture: texture,
                                frame: Constant.Frame.exitWorldButton,
                                text: "Exit World",
                                eventType: WorldEventType.menuExitButton)
        self.addChild(exitButton)

        let escapeButton = Button(texture: texture,
                                  frame: Constant.Frame.escapeButton,
                                  text: "escape",
                                  eventType: WorldEventType.menuEscapeButton)
        self.addChild(escapeButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - isHidden
    func reveal() {
        self.isHidden = false
        TouchManager.default.cancelAllTouches()
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

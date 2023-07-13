//
//  InfoWindownLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation
import SpriteKit

class InfoWindowLogic {

    private let infoWindow: InfoWindow

    init(infoWindow: InfoWindow) {
        self.infoWindow = infoWindow
    }

    func openCharacterInfo() {
        self.infoWindow.isHidden = false

        self.updateCharacterInfo()

        let y = self.infoWindow.frame.height / 2.0 + Constant.defaultPadding
        self.infoWindow.position = CGPoint(x: Constant.sceneCenter.x,
                                           y: Constant.sceneCenter.y + y)
    }

    func updateCharacterInfo() {
        let content = Logics.default.mastery.description
        self.infoWindow.setText(content)
    }

    func displayGOInfo(node: SKNode) {
    }

    func close() {
        self.infoWindow.hide()
    }

    func scrolled(_ diff: Double) {
        self.infoWindow.scrolled(diff)
    }

    func scrollEnded() {
        self.infoWindow.moveBackToContent()
    }

    func removeAllActions() {
        self.infoWindow.removeAllActions()
    }

}

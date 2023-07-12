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

    func displayCharacterInfo() {
        self.infoWindow.isHidden = false

        let content = Logics.default.mastery.description
        self.infoWindow.setText(content)

        let y = self.infoWindow.path!.boundingBox.size.height / 2.0 + Constant.defaultWidth
        self.infoWindow.position = CGPoint(x: Constant.sceneCenter.x,
                                           y: Constant.sceneCenter.y + y)
    }

    func displayGOInfo(node: SKNode) {

    }

    func hide() {
        self.infoWindow.hide()
    }

}

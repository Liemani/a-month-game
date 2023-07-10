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
    private let character: Character

    init(infoWindow: InfoWindow,
         character: Character) {
        self.infoWindow = infoWindow
        self.character = character
    }

    func displayCharacterInfo() {
        self.infoWindow.isHidden = false
        self.infoWindow.removeFromParent()
        self.character.addChild(self.infoWindow)

        let y = self.infoWindow.path!.boundingBox.size.height / 2.0 + Constant.defaultWidth
        self.infoWindow.position = CGPoint(x: 0, y: y)
    }

    func displayGOInfo(node: SKNode) {

    }

    func hide() {
        self.infoWindow.hide()
    }

}

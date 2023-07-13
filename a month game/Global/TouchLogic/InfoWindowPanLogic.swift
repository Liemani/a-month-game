//
//  InfoWindowPanLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class InfoWindowPanLogic: TouchLogic {

    var touch: UITouch { self.touches[0] }

    private let scene: SKScene

    init(touch: UITouch, scene: SKScene) {
        self.scene = scene

        super.init()

        self.touches.append(touch)
    }

    override func began() {
        Logics.default.infoWindow.removeAllActions()
    }

    override func moved() {
        let pPoint = touch.previousLocation(in: self.scene)
        let cPoint = touch.location(in: self.scene)

        let pointDeltaY = cPoint.y - pPoint.y

        Logics.default.infoWindow.scrolled(pointDeltaY)
    }

    override func ended() {
        Logics.default.infoWindow.scrollEnded()
    }

}

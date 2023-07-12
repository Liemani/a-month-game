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

    init(touch: UITouch) {
        super.init()

        self.touches.append(touch)
    }

    override func began() {
    }

    override func moved() {
        print("moving")
    }

    override func ended() {
    }

    override func cancelled() {
    }

}

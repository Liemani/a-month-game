//
//  PortalController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import UIKit

class PortalController {

    weak var viewController: ViewController!
    var portalScene: PortalScene!

    init() {
        let portalScene = PortalScene()

        portalScene.size = Constant.screenSize
        portalScene.scaleMode = .aspectFit
        portalScene.portalController = self

        self.portalScene = portalScene
    }

    func touchDown(_ touch: UITouch) {
    }

    func touchMoved(_ touch: UITouch) {
    }

    func touchUp(_ touch: UITouch) {
        let touchPoint = touch.location(in: self.portalScene.uiLayer)
        if self.portalScene.enterButton.contains(touchPoint) {
            viewController.setWorldScene()
        }

        if self.portalScene.resetButton.contains(touchPoint) {
            print("reset button is touched")
        }
    }

}

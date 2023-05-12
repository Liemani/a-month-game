//
//  PortalSceneController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import UIKit

class PortalSceneController {

    weak var viewController: ViewController!
    var portalScene: PortalScene!

    init() {
        let portalScene = PortalScene()

        portalScene.size = Constant.screenSize
        portalScene.scaleMode = .aspectFit
        portalScene.portalController = self

        self.portalScene = portalScene
    }

    func touchDown(touch: UITouch) {
    }

    func touchMoved(touch: UITouch) {
    }

    func touchUp(touch: UITouch) {
        let touchPoint = touch.location(in: self.portalScene.uiLayer)
        if self.portalScene.enterButton.contains(touchPoint) {
            viewController.setWorldScene()
        }

        if self.portalScene.resetButton.contains(touchPoint) {
            FileController(worldName: Constant.defaultWorldName).resetWorld()
        }
    }

}

//
//  PortalSceneController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import UIKit

class PortalSceneController: SceneController {

    required init(viewController: ViewController) {
        super.init(viewController: viewController)

        let scene = PortalScene()

        scene.size = Constant.sceneSize
        scene.scaleMode = .aspectFit
        scene.portalController = self

        self.scene = scene
    }

    func touchDown(touch: UITouch) {
    }

    func touchMoved(touch: UITouch) {
    }

    func touchUp(touch: UITouch) {
        let scene = self.scene as! PortalScene
        let touchPoint = touch.location(in: scene.uiLayer)
        if scene.enterButton.contains(touchPoint) {
            viewController.setWorldScene()
        }

        if scene.resetButton.contains(touchPoint) {
            let diskController = DiskController.default
            diskController.removeWorldDirectory(ofName: Constant.defaultWorldName)
        }
    }

}

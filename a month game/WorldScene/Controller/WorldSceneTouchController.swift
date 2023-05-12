//
//  WorldSceneTouchController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import UIKit
import SpriteKit

class WorldSceneTouchController {

    weak var worldController: WorldSceneController!
    var camera: SKCameraNode!

    var touchDownTimestamp: TimeInterval = 0.0
    var touchDownLocation: CGPoint = CGPoint()
    var velocityVector: CGVector = CGVector()

    // MARK: - init
    init(worldController: WorldSceneController) {
        self.worldController = worldController
    }

    // MARK: - touch
    func touchDown(touch: UITouch) {
        if !self.worldController.worldModel.isMenuOpen {
            startDragging(touch: touch)
        }
    }

    private func startDragging(touch: UITouch) {
        self.touchDownTimestamp = touch.timestamp
        self.touchDownLocation = touch.location(in: self.camera)
        self.velocityVector = CGVector()
    }

    func touchMoved(touch: UITouch) {
        moveCamera(touch: touch)
    }

    private func moveCamera(touch: UITouch) {
        let currentLocation = touch.location(in: self.camera)
        let previousLocation = touch.previousLocation(in: self.camera)

        let dx = currentLocation.x - previousLocation.x
        let dy = currentLocation.y - previousLocation.y

        let oldCameraPosition = self.camera.position
        let newCameraPosition = CGPoint(x: oldCameraPosition.x - dx, y: oldCameraPosition.y - dy)

        self.camera.position = newCameraPosition
    }

    func touchUp(touch: UITouch) {
        if !self.worldController.worldModel.isMenuOpen {
            let currentLocation = touch.location(in: self.camera)
            let timeInterval = touch.timestamp - touchDownTimestamp

            let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
            let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
            self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
            if self.worldController.worldScene.menuButtonNode.contains(currentLocation) {
                self.worldController.worldScene.menuLayer.isHidden = false
            }
        } else {
            let currentLocation = touch.location(in: self.camera)
            if self.worldController.worldScene.exitWorldButtonNode.contains(currentLocation) {
                performSegueToPortalScene()
            } else {
                self.worldController.worldScene.menuLayer.isHidden = true
            }
        }
    }

    private func performSegueToPortalScene() {
        self.worldController.viewController.setPortalScene()
    }

}

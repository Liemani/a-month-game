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
        if !self.worldController.isMenuOpen {
            let scene = self.worldController.scene as! WorldScene
            let touchLocation = touch.location(in: scene.fieldGameObjectLayer)
            if let touchedObject = scene.fieldGameObjectLayer.nodes(at: touchLocation).first {
                self.worldController.removeGameObject(bySpriteNode: touchedObject as! SKSpriteNode)
            } else {
                self.addGameItemAtTouchLocation(touch: touch)
            }
            self.startDragging(touch: touch)

        }
    }

    private func addGameItemAtTouchLocation(touch: UITouch) {
        let scene = self.worldController.scene as! WorldScene
        let location = touch.location(in: scene)
        let row = Int(location.x) / Int(Constant.defaultSize)
        let column = Int(location.y) / Int(Constant.defaultSize)
        let position = GameObjectCoordinate(inventoryID: 0, row: row, column: column)
        let gameItem = GameObjectSeedPineCone(id: nil, coordinate: position)
        self.worldController.add(gameObject: gameItem)
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
        let scene = self.worldController.scene as! WorldScene
        if !self.worldController.isMenuOpen {
            let currentLocation = touch.location(in: self.camera)
            let timeInterval = touch.timestamp - touchDownTimestamp

            let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
            let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
            self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
            if scene.menuButtonNode.contains(currentLocation) {
                scene.menuLayer.isHidden = false
            }
        } else {
            let currentLocation = touch.location(in: self.camera)
            if scene.exitWorldButtonNode.contains(currentLocation) {
                performSegueToPortalScene()
            } else {
                scene.menuLayer.isHidden = true
            }
        }
    }

    private func performSegueToPortalScene() {
        self.worldController.viewController.setPortalScene()
    }

}

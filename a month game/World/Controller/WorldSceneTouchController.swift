//
//  WorldSceneTouchController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import UIKit
import SpriteKit

class WorldSceneTouchController {

    weak var worldController: WorldController!
    var camera: SKCameraNode!

    var touchState = TouchState.none
    var touchDownTimestamp: TimeInterval = 0.0
    var touchDownLocation: CGPoint = CGPoint()
    var velocityVector: CGVector = CGVector()

    enum TouchState {
        case none
        case dragging
    }

    // MARK: - init
    init(worldController: WorldController) {
        self.worldController = worldController
    }

    // MARK: - touch
    func touchDown(_ touch: UITouch) {
        startDragging(touch: touch)
    }

    func startDragging(touch: UITouch) {
        self.touchDownTimestamp = touch.timestamp
        self.touchDownLocation = touch.location(in: self.camera)
        self.velocityVector = CGVector()
    }

    func touchMoved(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.camera)
        let previousLocation = touch.previousLocation(in: self.camera)
        let dx = currentLocation.x - previousLocation.x
        let dy = currentLocation.y - previousLocation.y
        let cameraPosition = self.camera.position
        self.camera.position = CGPoint(x: cameraPosition.x - dx, y: cameraPosition.y - dy)
    }

    func touchUp(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.camera)
        let timeInterval = touch.timestamp - touchDownTimestamp

        let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
        let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
        self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
    }

}

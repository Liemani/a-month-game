//
//  WorldController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import UIKit
import SpriteKit

class WorldSceneController: SceneController {

    var worldModel: WorldModel!
    var worldSceneTouchController: WorldSceneTouchController!

    var isMenuOpen: Bool {
        let scene = self.scene as! WorldScene
        return !scene.menuLayer.isHidden
    }

    // MARK: - init
    required init(viewController: ViewController) {
        super.init(viewController: viewController)

        let scene = WorldScene()

        scene.size = Constant.screenSize
        scene.scaleMode = .aspectFit
        scene.worldController = self

        let camera = SKCameraNode()
        camera.position = Constant.tileMapNodePosition
        scene.camera = camera
        scene.addChild(camera)

        self.scene = scene

        let worldSceneTouchController = WorldSceneTouchController(worldController: self)
        worldSceneTouchController.camera = camera
        self.worldSceneTouchController = worldSceneTouchController
    }

    convenience init(viewController: ViewController, worldName: String) {
        self.init(viewController: viewController)

        self.worldModel = WorldModel(worldController: self, worldName: worldName)
    }

    // MARK: - update
    var lastUpdateTime: TimeInterval = 0.0
    func update(currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        updateCamera(timeInterval: timeInterval)
        updateVelocity(timeInterval: timeInterval)
//        toggleTileIfPass1Sec(timeInterval: currentTime)

        lastUpdateTime = currentTime
    }

    func updateCamera(timeInterval: TimeInterval) {
        let cameraPosition = self.worldSceneTouchController.camera.position
        let newCameraPositionX = cameraPosition.x + self.worldSceneTouchController.velocityVector.dx * timeInterval
        let newCameraPositionY = cameraPosition.y + self.worldSceneTouchController.velocityVector.dy * timeInterval
        self.worldSceneTouchController.camera.position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)
    }

    func updateVelocity(timeInterval: TimeInterval) {
        let velocity = (self.worldSceneTouchController.velocityVector.dx * self.worldSceneTouchController.velocityVector.dx + self.worldSceneTouchController.velocityVector.dy * self.worldSceneTouchController.velocityVector.dy).squareRoot()
        if velocity <= Constant.velocityDamping * timeInterval {
            self.worldSceneTouchController.velocityVector = CGVectorMake(0.0, 0.0)
        } else {
            let newVelocityVectorX = self.worldSceneTouchController.velocityVector.dx - Constant.velocityDamping / velocity * self.worldSceneTouchController.velocityVector.dx * timeInterval
            let newVelocityVectorY = self.worldSceneTouchController.velocityVector.dy - Constant.velocityDamping / velocity * self.worldSceneTouchController.velocityVector.dy * timeInterval
            self.worldSceneTouchController.velocityVector = CGVector(dx: newVelocityVectorX, dy: newVelocityVectorY)
        }
    }

    var lastTileUpdateTime: TimeInterval = 0.0
    var tileUpdateCoord = Array<Int>(repeating: 0, count: 2)
    func toggleTileIfPass1Sec(currentTime: TimeInterval) {
        lastTileUpdateTime = lastTileUpdateTime == 0.0 ? currentTime : lastTileUpdateTime
        let timeInterval = currentTime - lastTileUpdateTime

        let timeExcess = timeInterval - 1.0
        if timeExcess >= 0.0 {
            self.toggleTile(row: tileUpdateCoord[0], column: tileUpdateCoord[1])

            let nextColumn = tileUpdateCoord[1] + 1

            tileUpdateCoord[0] = tileUpdateCoord[0] + nextColumn / Constant.gridSize
            tileUpdateCoord[1] = nextColumn % Constant.gridSize

            lastTileUpdateTime = currentTime - timeExcess
        }
    }

    func toggleTile(row: Int, column: Int) {
        let scene = self.scene as! WorldScene
        let newTileID = self.worldModel.tileMapModel.tileMap[100 * row + column] ^ 1
        self.worldModel.tileMapModel.setTile(row: row, column: column, tileID: newTileID)
        scene.setTile(row: row, column: column, tileID: newTileID)
    }

}

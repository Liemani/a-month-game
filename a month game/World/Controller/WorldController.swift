//
//  WorldController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import UIKit
import SpriteKit

class WorldController {

    weak var viewController: ViewController!
    var worldModel: WorldModel!
    var worldScene: WorldScene!
    var worldSceneTouchController: WorldSceneTouchController!

    // MARK: - init
    init(viewController: ViewController, worldName: String) {
        self.viewController = viewController
        self.worldModel = WorldModel(worldController: self, worldName: worldName)

        let worldScene = WorldScene()

        worldScene.size = Constant.screenSize
        worldScene.scaleMode = .aspectFit
        worldScene.worldController = self

        let camera = SKCameraNode()
        worldScene.camera = camera
        worldScene.addChild(camera)

        self.worldScene = worldScene

        let worldSceneTouchController = WorldSceneTouchController(worldController: self)
        worldSceneTouchController.camera = camera
        self.worldSceneTouchController = worldSceneTouchController
    }

    // MARK: - update
    var lastUpdateTime: TimeInterval = 0.0
    func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        updateCamera(timeInterval)
        updateVelocity(timeInterval)
//        toggleTileIfPass1Sec(currentTime)

        lastUpdateTime = currentTime
    }

    func updateCamera(_ timeInterval: TimeInterval) {
        let cameraPosition = self.worldSceneTouchController.camera.position
        let newCameraPositionX = cameraPosition.x + self.worldSceneTouchController.velocityVector.dx * timeInterval
        let newCameraPositionY = cameraPosition.y + self.worldSceneTouchController.velocityVector.dy * timeInterval
        self.worldSceneTouchController.camera.position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)
    }

    func updateVelocity(_ timeInterval: TimeInterval) {
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
    func toggleTileIfPass1Sec(_ currentTime: TimeInterval) {
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
        let newTileID = self.worldModel.tileMapModel.tileMap[100 * row + column] ^ 1
        self.worldModel.tileMapModel.setTile(row: row, column: column, tileID: newTileID)
        self.worldScene.setTile(row: row, column: column, tileID: newTileID)
    }

}

//
//  WorldController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import UIKit

class WorldController {

    weak var viewController: ViewController!
    var worldModel: WorldModel!
    var worldScene: WorldScene!

    init(viewController: ViewController, worldName: String) {
        self.viewController = viewController
        self.worldModel = WorldModel(worldController: self, worldName: worldName)

        let worldScene = WorldScene()

        worldScene.size = Constant.screenSize
        worldScene.scaleMode = .aspectFit
        worldScene.worldController = self

        self.worldScene = worldScene
    }

    // MARK: - touch
    var touchDownTimestamp: TimeInterval = 0.0
    var touchDownLocation: CGPoint = CGPoint()
    var velocityVector: CGVector = CGVector()

    func touchDown(_ touch: UITouch) {
        recordTouchDown(touch)
    }

    func recordTouchDown(_ touch: UITouch) {
        self.touchDownTimestamp = touch.timestamp
        self.touchDownLocation = touch.location(in: self.worldScene.camera!)
        self.velocityVector = CGVector()
    }

    func touchMoved(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.worldScene.camera!)
        let previousLocation = touch.previousLocation(in: self.worldScene.camera!)
        let dx = currentLocation.x - previousLocation.x
        let dy = currentLocation.y - previousLocation.y
        let cameraPosition = self.worldScene.camera!.position
        self.worldScene.camera!.position = CGPoint(x: cameraPosition.x - dx, y: cameraPosition.y - dy)
    }

    func touchUp(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.worldScene.camera!)
        let timeInterval = touch.timestamp - touchDownTimestamp

        let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
        let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
        self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
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
        let cameraPosition = self.worldScene.camera!.position
        let newCameraPositionX = cameraPosition.x + self.velocityVector.dx * timeInterval
        let newCameraPositionY = cameraPosition.y + self.velocityVector.dy * timeInterval
        self.worldScene.camera!.position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)
    }

    func updateVelocity(_ timeInterval: TimeInterval) {
        let velocity = (self.velocityVector.dx * self.velocityVector.dx + self.velocityVector.dy * self.velocityVector.dy).squareRoot()
        if velocity <= Constant.velocityDamping * timeInterval {
            self.velocityVector = CGVector()
        } else {
            let newVelocityVectorX = self.velocityVector.dx - Constant.velocityDamping / velocity * self.velocityVector.dx * timeInterval
            let newVelocityVectorY = self.velocityVector.dy - Constant.velocityDamping / velocity * self.velocityVector.dy * timeInterval
            self.velocityVector = CGVector(dx: newVelocityVectorX, dy: newVelocityVectorY)
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

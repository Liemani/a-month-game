//
//  GameController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import UIKit

class GameController {
    var gameModel: GameModel
    var gameScene: GameScene!

    init() {
        gameModel = GameModel()
        gameScene = GameScene(gameController: self)
    }

    // MARK: touch
    var touchDownTimestamp: TimeInterval = 0.0
    var touchDownLocation: CGPoint = CGPoint()
    var velocityVector: CGVector = CGVector()

    func touchDown(_ touch: UITouch) {
        recordTouchDown(touch)
    }

    func recordTouchDown(_ touch: UITouch) {
        self.touchDownTimestamp = touch.timestamp
        self.touchDownLocation = touch.location(in: self.gameScene.camera!)
        self.velocityVector = CGVector()
    }

    func touchMoved(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.gameScene.camera!)
        let previousLocation = touch.previousLocation(in: self.gameScene.camera!)
        let dx = currentLocation.x - previousLocation.x
        let dy = currentLocation.y - previousLocation.y
        let cameraPosition = self.gameScene.camera!.position
        self.gameScene.camera!.position = CGPoint(x: cameraPosition.x - dx, y: cameraPosition.y - dy)
    }

    func touchUp(_ touch: UITouch) {
        let currentLocation = touch.location(in: self.gameScene.camera!)
        let timeInterval = touch.timestamp - touchDownTimestamp

        print("currentLocation: \(currentLocation), touchDownLocation: \(touchDownLocation)")

        let velocityX = -(currentLocation.x - touchDownLocation.x) / timeInterval
        let velocityY = -(currentLocation.y - touchDownLocation.y) / timeInterval
        self.velocityVector = CGVector(dx: velocityX, dy: velocityY)
    }

    // MARK: update()
    var lastUpdateTime: TimeInterval = 0.0
    func update(_ currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        updateCamera(timeInterval)
        updateVelocity(timeInterval)
        updateTile(currentTime)

        lastUpdateTime = currentTime
    }

    func updateCamera(_ timeInterval: TimeInterval) {
        let cameraPosition = self.gameScene.camera!.position
        let newCameraPositionX = cameraPosition.x + self.velocityVector.dx * timeInterval
        let newCameraPositionY = cameraPosition.y + self.velocityVector.dy * timeInterval
        self.gameScene.camera!.position = CGPoint(x: newCameraPositionX, y: newCameraPositionY)
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
    func updateTile(_ currentTime: TimeInterval) {
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
        let targetTileID = self.gameModel.mapModel.tileMapData[row][column] ^ 1
        self.gameModel.mapModel.setTileData(row: row, column: column, tileID: targetTileID)
        self.gameScene.setTile(row: row, column: column, tileID: targetTileID)
    }
}

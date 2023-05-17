//
//  WorldSceneController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import UIKit
import SpriteKit

final class WorldSceneController: SceneController {

    var worldSceneModel: WorldSceneModel!
    var worldSceneTouchController: WorldSceneTouchController!

    var gameItemSpriteNodeToModelDictionary: [SKSpriteNode: GameObject] = [:]

    var isMenuOpen: Bool {
        let scene = self.scene as! WorldScene
        return !scene.menuLayer.isHidden
    }

    // MARK: - init
    required init(viewController: ViewController) {
        super.init(viewController: viewController)

        let scene = WorldScene()
        scene.setUp(worldSceneController: self)

        self.scene = scene

        let worldSceneTouchController = WorldSceneTouchController(worldController: self)
        worldSceneTouchController.camera = scene.camera
        self.worldSceneTouchController = worldSceneTouchController
    }

    convenience init(viewController: ViewController, worldName: String) {
        self.init(viewController: viewController)

        self.worldSceneModel = WorldSceneModel(worldSceneController: self, worldName: worldName)
        self.initSceneByModel()

        self.debugCode()
    }

    // MARK: - init scene by model
    private func initSceneByModel() {
        let scene = self.scene as! WorldScene

        let tileModel: WorldSceneTileModel = self.worldSceneModel.worldSceneTileModel
        for row in 0..<Constant.gridSize {
            for column in 0..<Constant.gridSize {
                let tileTypeID = tileModel.getTileTypeID(row: row, column: column)
                scene.set(row: row, column: column, tileTypeID: tileTypeID)
            }
        }

        let gameObjectDictionary = self.worldSceneModel.worldSceneGameObjectModel.gameObjectDictionary
        for gameObject in gameObjectDictionary.values {
            let scene = self.scene as! WorldScene
            let gameItemNode = scene.addSpriteNode(byGameObject: gameObject)

            self.gameItemSpriteNodeToModelDictionary[gameItemNode] = gameObject
        }
    }

    // MARK: - edit
    func add(gameObject: GameObject) {
        self.worldSceneModel.add(gameItem: gameObject)

        let scene = self.scene as! WorldScene
        let gameItemNode = scene.addSpriteNode(byGameObject: gameObject)

        self.gameItemSpriteNodeToModelDictionary[gameItemNode] = gameObject
    }

    func removeGameObject(bySpriteNode gameItemSpriteNode: SKSpriteNode) {
        let gameItem = self.gameItemSpriteNodeToModelDictionary[gameItemSpriteNode]!

        let scene = self.scene as! WorldScene
        scene.remove(gameItemSpriteNode: gameItemSpriteNode)

        self.worldSceneModel.remove(gameItem: gameItem)

        self.gameItemSpriteNodeToModelDictionary.removeValue(forKey: gameItemSpriteNode)
    }

    // MARK: - update
    var lastUpdateTime: TimeInterval = 0.0
    func update(currentTime: TimeInterval) {
        let timeInterval: TimeInterval = currentTime - lastUpdateTime

        updateCamera(timeInterval: timeInterval)
        updateVelocity(timeInterval: timeInterval)

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

    // MARK: - debug code
    func debugCode() {
        for gameItem in self.worldSceneModel.worldSceneGameObjectModel.gameObjectDictionary.values {
            print("id: \(gameItem.id), typeID: \(gameItem.typeID), position: \(gameItem.coordinate)")

        }

    }
//    var lastTileUpdateTime: TimeInterval = 0.0
//    var tileUpdateCoord = Array<Int>(repeating: 0, count: 2)
//    func toggleTileIfPass1Sec(currentTime: TimeInterval) {
//        lastTileUpdateTime = lastTileUpdateTime == 0.0 ? currentTime : lastTileUpdateTime
//        let timeInterval = currentTime - lastTileUpdateTime
//
//        let timeExcess = timeInterval - 1.0
//        if timeExcess >= 0.0 {
//            self.toggleTile(row: tileUpdateCoord[0], column: tileUpdateCoord[1])
//
//            let nextColumn = tileUpdateCoord[1] + 1
//
//            tileUpdateCoord[0] = tileUpdateCoord[0] + nextColumn / Constant.gridSize
//            tileUpdateCoord[1] = nextColumn % Constant.gridSize
//
//            lastTileUpdateTime = currentTime - timeExcess
//        }
//    }
//
//    func toggleTile(row: Int, column: Int) {
//        let scene = self.scene as! WorldScene
//        let newTileID = self.worldModel.tileMapModel.tileMap[100 * row + column] ^ 1
//        self.worldModel.tileMapModel.setTile(row: row, column: column, tileID: newTileID)
//        scene.setTile(row: row, column: column, tileID: newTileID)
//    }

}

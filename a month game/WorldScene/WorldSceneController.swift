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

    var gameObjectNodeToModelDictionary: [SKNode: GameObject] = [:]

    // MARK: - init
    required init(viewController: ViewController) {
        super.init(viewController: viewController)

        self.initDelegateReference()

        let scene = WorldScene()
        scene.setUp(worldSceneController: self)

        self.scene = scene
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
            let gameObjectNode = scene.addSpriteNode(byGameObject: gameObject)

            self.gameObjectNodeToModelDictionary[gameObjectNode] = gameObject
        }
    }

    // MARK: - edit model and scene
    func add(_ gameObject: GameObject) {
        self.worldSceneModel.add(gameObject: gameObject)

        let scene = self.scene as! WorldScene
        let gameObjectNode = scene.addSpriteNode(byGameObject: gameObject)

        self.gameObjectNodeToModelDictionary[gameObjectNode] = gameObject
    }

    func removeGameObject(by gameObjectNode: SKNode) {
        let gameObject = self.gameObjectNodeToModelDictionary[gameObjectNode]!

        let scene = self.scene as! WorldScene
        scene.remove(gameObjectNode: gameObjectNode)

        self.worldSceneModel.remove(gameObject: gameObject)

        self.gameObjectNodeToModelDictionary.removeValue(forKey: gameObjectNode)
    }

    // TODO: implement hand
    func interactObject(by node: SKNode) {
        let gameObject = self.gameObjectNodeToModelDictionary[node]!
        gameObject.interact(leftHand: nil, rightHand: nil)
    }

    // MARK: - debug code
    func debugCode() {
        for gameObject in self.worldSceneModel.worldSceneGameObjectModel.gameObjectDictionary.values {
            print("id: \(gameObject.id), coordinate: \(gameObject.coordinate), typeID: \(Resource.getTypeID(of: gameObject))")
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

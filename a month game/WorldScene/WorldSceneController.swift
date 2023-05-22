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

    var gameObjectToMO: [GameObject: GameObjectMO] = [:]

    // MARK: - init
    // TODO: clean
    init(viewController: ViewController, worldName: String) {
        super.init(viewController: viewController)

        self.worldSceneModel = WorldSceneModel(worldSceneController: self, worldName: worldName)

        let scene = WorldScene()
        scene.initialize(worldSceneController: self)
        self.scene = scene
        self.initSceneByModel()

        self.debugCode()
    }

    private func initSceneByModel() {
        let scene = self.scene as! WorldScene

        let tileModel: TileMapModel = self.worldSceneModel.tileMapModel
        for x in 0..<Constant.gridSize {
            for y in 0..<Constant.gridSize {
                let tileType = tileModel.getTileType(fromX: x, y: y)
                scene.set(tileType: tileType, toX: x, y: y)
            }
        }

        let gameObjectMOArray = self.worldSceneModel.loadGameObjectDictionary()
        for gameObjectMO in gameObjectMOArray {
            let scene = self.scene as! WorldScene
            let gameObject = scene.add(by: gameObjectMO)

            self.gameObjectToMO[gameObject] = gameObjectMO
        }

        let characterCoordinate = self.worldSceneModel.characterModel.coordinate
        let position = (characterCoordinate.toCGPoint() + 0.5) * Constant.tileSide
        scene.movingLayer.position = -position
    }

    func debugCode() {
        for gameObjectMO in self.gameObjectToMO.values {
            print("id: \(gameObjectMO.id), typeID: \(gameObjectMO.typeID), inventoryID: \(gameObjectMO.inventoryID), coordinate: (\(gameObjectMO.x), \(gameObjectMO.y))")
        }
    }

    // MARK: - edit model and scene
    func add(_ gameObjectMO: GameObjectMO) {
//        let gameObjectMO = GameObjectMO()
//
//        gameObjectMO.id = Int32(IDGenerator.default.generate())
//        gameObjectMO.typeID = Int32(gameObject.typeID)
//        gameObjectMO.inventory = Int32(gameObject.inventoryID)
//        gameObjectMO.x = Int32(gameObject.coordinate.x)
//        gameObjectMO.y = Int32(gameObject.coordinate.y)

        let scene = self.scene as! WorldScene
        let gameObjectNode = scene.add(by: gameObjectMO)

        self.gameObjectToMO[gameObjectNode] = gameObjectMO
    }

    func removeGameObject(by gameObject: GameObject) {
        let gameObjectMO = self.gameObjectToMO[gameObject]!

        self.gameObjectToMO.removeValue(forKey: gameObject)
        gameObject.removeFromParent()

        self.worldSceneModel.remove(gameObjectMO)
    }

    func interact(with gameObject: GameObject, leftHand: SKNode?, righthand: SKNode?) {
        // TODO: implement hand
        gameObject.interact(leftHand: nil, rightHand: nil)
    }

    // MARK: - etc
    // TODO: move
    func move(_ gameObject: GameObject, to newCoordinate: GameObjectCoordinate) {
        let gameObjectMO = self.gameObjectToMO[gameObject]!

        gameObjectMO.inventoryID = Int32(newCoordinate.inventoryType.rawValue)
        gameObjectMO.x = Int32(newCoordinate.x)
        gameObjectMO.y = Int32(newCoordinate.y)

        self.worldSceneModel.contextSave()
    }

}

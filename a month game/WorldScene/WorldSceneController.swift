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

    var worldScene: WorldScene { return self.scene as! WorldScene }

    // MARK: - init
    // TODO: clean
    init(viewController: ViewController, worldName: String) {
        super.init(viewController: viewController)

        self.worldSceneModel = WorldSceneModel(worldSceneController: self, worldName: worldName)

        self.scene = WorldScene()
        self.setUpScene()

        #if DEBUG
        self.debugCode()
        #endif
    }

    private func setUpScene() {
        self.worldScene.setUp(sceneController: self)

        let tileModel: TileMapModel = self.worldSceneModel.tileMapModel
        for x in 0..<Constant.gridSize {
            for y in 0..<Constant.gridSize {
                let tileType = tileModel.tileType(atX: x, y: y)
                self.worldScene.set(tileType: tileType, toX: x, y: y)
            }
        }

        let gameObjectMOArray = self.worldSceneModel.loadGameObjectDictionary()
        for gameObjectMO in gameObjectMOArray {
            guard let gameObject = self.worldScene.add(by: gameObjectMO) else { continue }

            self.gameObjectToMO[gameObject] = gameObjectMO
        }

        let characterCoordinate = self.worldSceneModel.characterModel.coordinate
        let position = (characterCoordinate.toCGPoint() + 0.5) * Constant.tileSide
        self.worldScene.movingLayer.position = -position
    }

#if DEBUG
    func debugCode() {
        for gameObjectMO in self.gameObjectToMO.values {
            print("id: \(gameObjectMO.id), typeID: \(gameObjectMO.typeID), containerID: \(gameObjectMO.containerID), coordinate: (\(gameObjectMO.x), \(gameObjectMO.y))")
        }
    }
#endif

    // MARK: - edit model and scene
    // TODO: review after implementing GameObject.interact()
//    func add(_ gameObject: GameObject) {
//        let scene = self.scene as! WorldScene
//        let gameObjectNode = scene.add(by: gameObjectMO)
//
//        self.gameObjectToMO[gameObjectNode] = gameObjectMO
//    }

    func removeGameObject(by gameObject: GameObject) {
        let gameObjectMO = self.gameObjectToMO[gameObject]!

        self.gameObjectToMO.removeValue(forKey: gameObject)
        gameObject.removeFromParent()

        self.worldSceneModel.remove(gameObjectMO)
    }

    // MARK: - etc
    // TODO: move
    func move(_ gameObject: GameObject, to newCoordinate: GameObjectCoordinate) {
        let gameObjectMO = self.gameObjectToMO[gameObject]!

        gameObjectMO.containerID = Int32(newCoordinate.containerType.rawValue)
        gameObjectMO.x = Int32(newCoordinate.x)
        gameObjectMO.y = Int32(newCoordinate.y)

        self.worldSceneModel.contextSave()
    }

}

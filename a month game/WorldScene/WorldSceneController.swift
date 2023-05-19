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
        for x in 0..<Constant.gridSize {
            for y in 0..<Constant.gridSize {
                let tileType = tileModel.getTileType(fromX: x, y: y)
                scene.set(tileType: tileType, toX: x, y: y)
            }
        }

        let gameObjectDictionary = self.worldSceneModel.worldSceneGameObjectModel.gameObjectDictionary
        for gameObject in gameObjectDictionary.values {
            let scene = self.scene as! WorldScene
            let gameObjectNode = scene.add(gameObject)

            self.gameObjectNodeToModelDictionary[gameObjectNode] = gameObject
        }
    }

    // MARK: - edit model and scene
    func add(_ gameObject: GameObject) {
        self.worldSceneModel.add(gameObject)

        let scene = self.scene as! WorldScene
        let gameObjectNode = scene.add(gameObject)

        self.gameObjectNodeToModelDictionary[gameObjectNode] = gameObject
    }

    func removeGameObject(by gameObjectNode: SKNode) {
        let gameObject = self.gameObjectNodeToModelDictionary[gameObjectNode]!

        self.gameObjectNodeToModelDictionary.removeValue(forKey: gameObjectNode)

        self.worldSceneModel.remove(gameObject)
        gameObjectNode.removeFromParent()
    }

    // TODO: implement hand
    func interactObject(by node: SKNode) {
        let gameObject = self.gameObjectNodeToModelDictionary[node]!
        gameObject.interact(leftHand: nil, rightHand: nil)
    }

    // MARK: - debug code
    func debugCode() {
        for gameObject in self.worldSceneModel.worldSceneGameObjectModel.gameObjectDictionary.values {
            print("id: \(gameObject.id), coordinate: \(gameObject.coordinate), type: \(Resource.getTypeID(of: gameObject))")
        }

    }

}

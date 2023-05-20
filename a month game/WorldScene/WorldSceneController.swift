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

    var gameObjectNodeToModel: [SKNode: GameObject] = [:]

    // MARK: - init
    required init(viewController: ViewController) {
        super.init(viewController: viewController)

        self.setGameObjectDelegateReference()

    }

    convenience init(viewController: ViewController, worldName: String) {
        self.init(viewController: viewController)

        self.worldSceneModel = WorldSceneModel(worldSceneController: self, worldName: worldName)

        let scene = WorldScene()

        scene.setUp(worldSceneController: self)

        self.scene = scene

        self.initSceneByModel()

        self.debugCode()
    }

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

            self.gameObjectNodeToModel[gameObjectNode] = gameObject
        }

        let characterCoordinate = self.worldSceneModel.characterModel.coordinate
        let position = (characterCoordinate.toCGPoint() + 0.5) * Constant.tileSide
        scene.movingLayer.position = -position
    }

    // MARK: - edit model and scene
    func add(_ gameObject: GameObject) {
        self.worldSceneModel.add(gameObject)

        let scene = self.scene as! WorldScene
        let gameObjectNode = scene.add(gameObject)

        self.gameObjectNodeToModel[gameObjectNode] = gameObject
    }

    func removeGameObject(by gameObjectNode: SKNode) {
        let gameObject = self.gameObjectNodeToModel[gameObjectNode]!

        self.gameObjectNodeToModel.removeValue(forKey: gameObjectNode)

        self.worldSceneModel.remove(gameObject)
        gameObjectNode.removeFromParent()
    }

    func interact(with node: SKNode, leftHand: SKNode?, righthand: SKNode?) {
        // TODO: implement hand
        let gameObject = self.gameObjectNodeToModel[node]!
        gameObject.interact(leftHand: nil, rightHand: nil)
    }

    // MARK: -etc
    // TODO: implement: move gameObject data to specific coordinate
    // TODO: move
    func move(_ gameObjectNode: SKNode, to coordinate: GameObjectCoordinate) {
    }

    // MARK: - debug code
    func debugCode() {
        for gameObject in self.worldSceneModel.worldSceneGameObjectModel.gameObjectDictionary.values {
            print("id: \(gameObject.id), coordinate: \(gameObject.coordinate), type: \(Resource.getTypeID(of: gameObject))")
        }
    }

}

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

    var goToMO: [GameObject: GameObjectMO] = [:]

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

        let goMOs = self.worldSceneModel.loadGOs()
        for goMO in goMOs {
            guard let go = self.worldScene.add(by: goMO) else { continue }

            self.goToMO[go] = goMO
        }

        let characterCoordinate = self.worldSceneModel.characterModel.coordinate
        let position = (characterCoordinate.toCGPoint() + 0.5) * Constant.tileSide
        self.worldScene.movingLayer.position = -position
    }

#if DEBUG
    func debugCode() {
        for goMO in self.goToMO.values {
            print("id: \(goMO.id), typeID: \(goMO.typeID), containerID: \(goMO.containerID), coordinate: (\(goMO.x), \(goMO.y))")
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

    func removeGO(by go: GameObject) {
        let goMO = self.goToMO[go]!

        self.goToMO.removeValue(forKey: go)
        go.removeFromParent()

        self.worldSceneModel.remove(goMO)
    }

    func move(_ go: GameObject, to newCoordinate: GameObjectCoordinate) {
        let goMO = self.goToMO[go]!

        goMO.containerID = Int32(newCoordinate.containerType.rawValue)
        goMO.x = Int32(newCoordinate.x)
        goMO.y = Int32(newCoordinate.y)

        self.worldSceneModel.contextSave()
    }

}

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

        let goMOs = self.worldSceneModel.loadGOs()
        for goMO in goMOs {
            guard let go = self.worldScene.add(by: goMO) else { continue }

            self.gameObjectToMO[go] = goMO
        }

        let characterCoord = self.worldSceneModel.characterModel.coordinate
        let position = (characterCoord.toCGPoint() + 0.5) * Constant.tileSide
        self.worldScene.movingLayer.position = -position
    }

#if DEBUG
    func debugCode() {
        for goMO in self.gameObjectToMO.values {
            print("id: \(goMO.id), typeID: \(goMO.typeID), containerID: \(goMO.containerID), coordinate: (\(goMO.x), \(goMO.y))")
        }
    }
#endif

    // MARK: - edit model and scene
    func add(_ goMO: GameObjectMO) {
        guard let go = self.worldScene.add(by: goMO) else {
            return
        }

        self.gameObjectToMO[go] = goMO
    }

    func add(gameObjectType goType: GameObjectType, containerType: ContainerType, x: Int, y: Int) {
        let newGOMO = self.worldSceneModel.newGOMO()
        newGOMO.setUp(gameObjectType: goType, containerType: containerType, x: x, y: y)
        self.worldSceneModel.contextSave()

        self.add(newGOMO)
    }

    func removeGO(by go: GameObject) {
        let goMO = self.gameObjectToMO[go]!

        self.gameObjectToMO.removeValue(forKey: go)
        go.removeFromParent()

        self.worldSceneModel.remove(goMO)
    }

    func move(_ go: GameObject, to newCoord: GameObjectCoordinate) {
        let goMO = self.gameObjectToMO[go]!

        goMO.containerID = Int32(newCoord.containerType.rawValue)
        goMO.x = Int32(newCoord.x)
        goMO.y = Int32(newCoord.y)

        self.worldSceneModel.contextSave()
    }

    // MARK: - etc
    /// - Returns: Return value is bit flag describing Nth space of clockwise order is possessed.
    func spareSpaces(_ selfGOMO: GameObjectMO) -> [Coordinate<Int>] {
        var occupySpaceBitFlags: UInt8 = 0

        // TODO: move to constant
        let spaceShiftTable: [UInt8] = [
            6, 7, 0,
            5, 8, 1,
            4, 3, 2,
        ]

        let selfCoord = selfGOMO.coordinate
        for goMO in self.gameObjectToMO.values {
            let goMOCoord = goMO.coordinate
            if goMOCoord.isAdjacent(with: selfCoord) {
                let differenceX = goMOCoord.x - selfCoord.x
                let differenceY = goMOCoord.y - selfCoord.y
                let tableIndex = (differenceY - 1) * -3 + (differenceX + 1)
                occupySpaceBitFlags |= 0x1 << spaceShiftTable[tableIndex]
            }
        }

        // TODO: move to constant
        let coordVectorTable = [
            Coordinate(1, 1),
            Coordinate(1, 0),
            Coordinate(1, -1),
            Coordinate(0, -1),
            Coordinate(-1, -1),
            Coordinate(-1, 0),
            Coordinate(-1, 1),
            Coordinate(0, 1),
        ]

        var spareSpaces: [Coordinate<Int>] = []

        for index in 0..<8 {
            if (occupySpaceBitFlags >> index) & 0x1 == 0x0 {
                spareSpaces.append(coordVectorTable[index])
            }
        }

        return spareSpaces
    }

    // MARK: - interact
    func interact(_ touchedGO: GameObject, leftHand lGO: GameObject?, rightHand rGO: GameObject?) {
        switch touchedGO.type {
        case .pineTree:
            guard Double.random(in: 0.0...1.0) <= 0.33 else { return }

            let goMO = self.gameObjectToMO[touchedGO]!
            let spareSpaces = self.spareSpaces(goMO)

            guard !spareSpaces.isEmpty else { return }

            let coordToAdd = spareSpaces[Int.random(in: 0..<spareSpaces.count)]
            let newGOMOCoord = goMO.coordinate + coordToAdd

            let typeType = GameObjectType.branch
            let containerType = ContainerType.field
            let x = newGOMOCoord.x
            let y = newGOMOCoord.y

            let newGOMO = self.worldSceneModel.newGOMO()
            newGOMO.setUp(gameObjectType: typeType, containerType: containerType, x: x, y: y)
            self.worldSceneModel.contextSave()

            self.add(newGOMO)
        default: break
        }
    }

}

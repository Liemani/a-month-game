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

    var goMOGO: GOMOGO = GOMOGO()

    var worldScene: WorldScene { self.scene as! WorldScene }

    // MARK: - init
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
        self.addGOs(goMOs)

        let characterPosition = self.worldSceneModel.characterModel.position
        self.worldScene.characterPosition = characterPosition
    }

#if DEBUG
    func debugCode() {
        for goMO in self.goMOGO.goMOs {
            print("id: \(goMO.id), typeID: \(goMO.typeID), containerID: \(goMO.containerID), coordinate: (\(goMO.x), \(goMO.y))")
        }
    }
#endif

    // MARK: - edit model and scene
    func addGOs(_ goMOs: [GameObjectMO]) {
        for goMO in goMOs {
            if let go = self.worldScene.addGO(from: goMO) {
                self.goMOGO[goMO] = go
            }
        }
        self.worldScene.interactionZone.update()
    }

    /// Save the context manually
    /// Apply scene gos change manually
    func addGOMO(gameObjectType goType: GameObjectType, goCoord: GameObjectCoordinate) {
        let goMO = self.worldSceneModel.newGOMO(gameObjectType: goType, goCoord: goCoord)
        if let go = self.worldScene.addGO(from: goMO) {
            self.goMOGO[goMO] = go
        }
    }

    func moveGOMO(from go: GameObject, to goCoord: GameObjectCoordinate) {
        let goMO = self.goMOGO[go]!
        goMO.set(goCoord: goCoord)
        self.worldSceneModel.contextSave()

        self.worldScene.moveGO(go, to: goCoord)
    }

    func removeGOMO(from gos: [GameObject]) {
        for go in gos {
            let goMO = self.goMOGO.remove(go)!
            self.worldSceneModel.remove(goMO)
            go.removeFromParent()
        }
        self.worldSceneModel.contextSave()
        self.worldScene.interactionZone.update()
    }

    // MARK: - etc
    /// - Returns: Return value is bit flag describing Nth space of clockwise order is possessed.
    func spareDirections(_ lhGOMO: GameObjectMO) -> [Coordinate<Int>] {
        var occupySpaceBitFlags: UInt8 = 0

        let spaceShiftTable: [UInt8] = Constant.spaceShiftTable

        let lhGOMOCoord = lhGOMO.coordinate
        for rhGOMO in self.goMOGO.goMOsInField {
            let rhGOMOCoord = rhGOMO.coordinate
            if lhGOMOCoord.isAdjacent(to: rhGOMOCoord) {
                let differenceX = rhGOMOCoord.x - lhGOMOCoord.x
                let differenceY = rhGOMOCoord.y - lhGOMOCoord.y
                let tableIndex = (differenceY - 1) * -3 + (differenceX + 1)
                occupySpaceBitFlags |= 0x1 << spaceShiftTable[tableIndex]
            }
        }

        let coordVectorTable = Constant.coordVectorTable

        var spareSpaces: [Coordinate<Int>] = []

        for index in 0..<8 {
            if (occupySpaceBitFlags >> index) & 0x1 == 0x0 {
                spareSpaces.append(coordVectorTable[index])
            }
        }

        return spareSpaces
    }

    // MARK: - interact
    func interact(_ go: GameObject, leftHand lGO: GameObject?, rightHand rGO: GameObject?) {
        guard go.parent is Field else {
            return
        }

        switch go.type {
        case .pineTree:
            guard Double.random(in: 0.0...1.0) <= 0.33 else {
                return
            }

            let goMO = self.goMOGO.field[go]!
            let spareDirections = self.spareDirections(goMO)

            guard !spareDirections.isEmpty else {
                return
            }

            let coordToAdd = spareDirections[Int.random(in: 0..<spareDirections.count)]
            let newGOMOCoord = goMO.coordinate + coordToAdd

            let goType = GameObjectType.branch
            let goCoord = GameObjectCoordinate(containerType: .field, x: newGOMOCoord.x, y: newGOMOCoord.y)

            self.addGOMO(gameObjectType: goType, goCoord: goCoord)
            self.worldSceneModel.contextSave()
            self.worldScene.interactionZone.update()
        default: break
        }
    }

}

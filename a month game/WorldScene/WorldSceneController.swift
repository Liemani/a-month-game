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
    func addGO(_ goMO: GameObjectMO) {
        if let go = self.worldScene.add(from: goMO) {
            self.goMOGO[goMO] = go
        }
    }

    func addGOs(_ goMOs: [GameObjectMO]) {
        for goMO in goMOs {
            if let go = self.worldScene.add(from: goMO) {
                self.goMOGO[goMO] = go
            }
        }
        self.worldScene.applyGOsUpdate()
    }

    func add(gameObjectType goType: GameObjectType, containerType: ContainerType, x: Int, y: Int) {
        let newGOMO = self.worldSceneModel.newGOMO()
        newGOMO.setUp(gameObjectType: goType, containerType: containerType, x: x, y: y)
        self.worldSceneModel.contextSave()

        self.addGO(newGOMO)
    }

    func move(_ go: GameObject, to newCoord: GameObjectCoordinate) {
        let goMO = self.goMOGO[go]!

        goMO.containerID = Int32(newCoord.containerType.rawValue)
        goMO.x = Int32(newCoord.x)
        goMO.y = Int32(newCoord.y)

        self.worldSceneModel.contextSave()
    }

    func remove(_ goMO: GameObjectMO) {
        let go = self.goMOGO.remove(goMO)!
        self.worldScene.remove(go)
        self.worldSceneModel.remove(goMO)
    }

    func remove(_ goMOs: [GameObjectMO]) {
        for goMO in goMOs {
            let go = self.goMOGO.remove(goMO)!
            self.worldScene.remove(go)
            self.worldSceneModel.remove(goMO)
        }
        self.worldScene.applyGOsUpdate()
    }

    func remove(_ go: GameObject) {
        let goMO = self.goMOGO.remove(go)!
        self.worldScene.remove(go)
        self.worldSceneModel.remove(goMO)
    }

    func remove(_ gos: [GameObject]) {
        for go in gos {
            let goMO = self.goMOGO.remove(go)!
            self.worldScene.remove(go)
            self.worldSceneModel.remove(goMO)
        }
        self.worldScene.applyGOsUpdate()
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
    func interact(_ touchedGO: GameObject, leftHand lGO: GameObject?, rightHand rGO: GameObject?) {
        switch touchedGO.type {
        case .pineTree:
            guard Double.random(in: 0.0...1.0) <= 0.33 else {
                return
            }

            let goMO = self.goMOGO.field[touchedGO]!
            let spareDirections = self.spareDirections(goMO)

            guard !spareDirections.isEmpty else {
                return
            }

            let coordToAdd = spareDirections[Int.random(in: 0..<spareDirections.count)]
            let newGOMOCoord = goMO.coordinate + coordToAdd

            let typeType = GameObjectType.branch
            let containerType = ContainerType.field
            let x = newGOMOCoord.x
            let y = newGOMOCoord.y

            let newGOMO = self.worldSceneModel.newGOMO()
            newGOMO.setUp(gameObjectType: typeType, containerType: containerType, x: x, y: y)
            self.worldSceneModel.contextSave()

            self.addGO(newGOMO)
        default: break
        }
    }

}

//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

/// Control world scene model and DiskController
final class WorldSceneModel {

    weak var worldScene: WorldScene!

    var diskController: DiskController!

    var tileMapModel: TileMapModel!

    var didChanged: Bool

    // MARK: - init
    init(worldScene: WorldScene, worldName: String) {
        self.worldScene = worldScene

        let diskController = DiskController.default
        diskController.setToWorld(ofName: worldName)
        self.diskController = diskController

        let tileMapData = self.diskController.loadTileData()
        self.tileMapModel = TileMapModel(tileMapData: tileMapData)

        self.didChanged = false
    }

    func loadGOMOs() -> [GameObjectMO] {
        return self.diskController.loadGOMOs()
    }

    deinit {
        self.diskController.close()
    }

    // MARK: - edit
    func update(tileType: Int, toX x: Int, y: Int) {
        self.tileMapModel.set(tileType: tileType, toX: x, y: y)

        var value = tileType
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.diskController.save(tileData: tileData, toX: x, y: y)
    }

    /// Call contextSave() manually
    func newGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObjectMO {
        let newGOMO = self.diskController.newGOMO()
        newGOMO.set(gameObjectType: goType, goCoord: goCoord)
        self.didChanged = true
        return newGOMO
    }

    func setGOMO(_ goMO: GameObjectMO, to goCoord: GameObjectCoordinate) {
        goMO.set(to: goCoord)
        self.didChanged = true
    }

    func remove(_ goMO: GameObjectMO) {
        self.diskController.delete(goMO)
        self.didChanged = true
    }

    func contextSave() {
        if self.didChanged {
            self.diskController.contextSave()
        }
        self.didChanged = false
    }

}

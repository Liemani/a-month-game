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
    var characterModel: CharacterModel!

    // MARK: - init
    init(worldSceneController: WorldScene, worldName: String) {
        let diskController = DiskController.default
        diskController.setToWorld(ofName: worldName)
        self.diskController = diskController

        self.worldScene = worldSceneController

        let tileMapData = self.diskController.loadTileData()
        self.tileMapModel = TileMapModel(tileMapData: tileMapData)

        self.characterModel = CharacterModel(worldScene: self.worldScene)
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
    func newGOMO(gameObjectType goType: GameObjectType, goCoord: GameObjectCoordinate) -> GameObjectMO {
        let newGOMO = self.diskController.newGOMO()
        newGOMO.set(gameObjectType: goType, goCoord: goCoord)
        return newGOMO
    }

    func remove(_ goMO: GameObjectMO) {
        self.diskController.delete(goMO)
    }

    func contextSave() {
        self.diskController.contextSave()
    }

}

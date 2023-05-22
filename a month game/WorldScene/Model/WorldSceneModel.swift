//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

/// Control world scene model and DiskController
final class WorldSceneModel {

    var diskController: DiskController!

    weak var worldSceneController: WorldSceneController!

    var tileMapModel: TileMapModel!
    var characterModel: CharacterModel!

    // MARK: - init
    init(worldSceneController: WorldSceneController, worldName: String) {
        let diskController = DiskController.default
        diskController.setToWorld(ofName: worldName)
        self.diskController = diskController

        self.worldSceneController = worldSceneController

        let tileMapData = self.diskController.loadTileData()
        self.tileMapModel = TileMapModel(tileMapData: tileMapData)

        self.characterModel = CharacterModel()
    }

    func loadGameObjectDictionary() -> [GameObjectMO] {
        return self.diskController.loadGameObjectManagedObjectArray()
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

    func add(_ gameObjectMO: GameObjectMO) {
        self.diskController.store(gameObjectMO)
    }

    func remove(_ gameObjectMO: GameObjectMO) {
        self.diskController.delete(gameObjectMO)
    }

    func contextSave() {
        self.diskController.contextSave()
    }

}

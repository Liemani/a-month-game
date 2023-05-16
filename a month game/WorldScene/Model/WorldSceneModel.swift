//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class WorldSceneModel {

    var diskController: DiskController!

    weak var worldController: WorldSceneController!

    var worldSceneTileModel: WorldSceneTileModel!
    var worldSceneGameObjectModel: WorldSceneGameObjectModel!

    // MARK: - init
    init(worldSceneController: WorldSceneController, worldName: String) {
        let diskController = DiskController.default
        diskController.setToWorld(ofName: worldName)
        self.diskController = diskController

        self.worldController = worldSceneController

        let tileMapData = self.diskController.loadTileData()
        self.worldSceneTileModel = WorldSceneTileModel(worldModel: self, tileMapData: tileMapData)

        let gameObjectDictionary = diskController.loadGameObjectDictionary()
        self.worldSceneGameObjectModel = WorldSceneGameObjectModel(worldSceneModel: self, gameItemDictionary: gameObjectDictionary)
    }

    // MARK: - deinit
    deinit {
        diskController.closeFiles()
    }

    // MARK: - edit
    func updateTile(row: Int, column: Int, tileTypeID: Int) {
        self.worldSceneTileModel.set(row: row, column: column, tileTypeID: tileTypeID)

        var value = tileTypeID
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.diskController.saveTileData(row: row, column: column, tileData: tileData)
    }

    func add(gameItem: GameObject) {
        self.worldSceneGameObjectModel.add(gameItem: gameItem)

        self.diskController.store(gameObject: gameItem)
    }

    func remove(gameItem: GameObject) {
        self.worldSceneGameObjectModel.remove(gameItem: gameItem)

        self.diskController.delete(gameObject: gameItem)
    }

}

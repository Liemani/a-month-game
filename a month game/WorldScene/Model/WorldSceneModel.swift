//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

/// Use DiskController to set self
final class WorldSceneModel {

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

        let gameObjectDictionary = self.loadGameObjectDictionary()
        self.worldSceneGameObjectModel = WorldSceneGameObjectModel(worldSceneModel: self, gameObjectDictionary: gameObjectDictionary)
    }

    // MARK: - deinit
    deinit {
        diskController.closeFiles()
    }

    // MARK: - edit
    func loadGameObjectDictionary() -> Dictionary<Int, GameObject> {
        var gameObjectDictionary = Dictionary<Int, GameObject>()

        let gameObjectManagedObjectArray = self.diskController.loadGameObjectManagedObjectArray()
        for gameObjectManagedObject in gameObjectManagedObjectArray {
            let id = Int(gameObjectManagedObject.id)
            let coordinate = GameObjectCoordinate(
                inventoryID: Int(gameObjectManagedObject.inventoryID),
                row: Int(gameObjectManagedObject.row),
                column: Int(gameObjectManagedObject.column))
            let typeID = Int(gameObjectManagedObject.typeID)
            let gameObject = GameObject.new(id: id, coordinate: coordinate, typeID: typeID)
            gameObjectDictionary[id] = gameObject
        }

        return gameObjectDictionary
    }

    func updateTile(row: Int, column: Int, tileTypeID: Int) {
        self.worldSceneTileModel.set(row: row, column: column, tileTypeID: tileTypeID)

        var value = tileTypeID
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.diskController.saveTileData(row: row, column: column, tileData: tileData)
    }

    func add(gameObject: GameObject) {
        self.worldSceneGameObjectModel.add(gameObject: gameObject)

        self.diskController.store(gameObject: gameObject)
    }

    func remove(gameObject: GameObject) {
        self.worldSceneGameObjectModel.remove(gameObject: gameObject)

        self.diskController.delete(gameObject: gameObject)
    }

}

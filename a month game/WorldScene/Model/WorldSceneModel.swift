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

    var worldSceneTileModel: WorldSceneTileModel!
    var worldSceneGameObjectModel: WorldSceneGameObjectModel!

    // MARK: - init
    init(worldSceneController: WorldSceneController, worldName: String) {
        let diskController = DiskController.default
        diskController.setToWorld(ofName: worldName)
        self.diskController = diskController

        self.worldSceneController = worldSceneController

        let tileMapData = self.diskController.loadTileData()
        self.worldSceneTileModel = WorldSceneTileModel(tileMapData: tileMapData)

        let gameObjectDictionary = self.loadGameObjectDictionary()
        self.worldSceneGameObjectModel = WorldSceneGameObjectModel(gameObjectDictionary: gameObjectDictionary)
    }

    deinit {
        self.diskController.close()
    }

    // MARK: - edit
    func loadGameObjectDictionary() -> Dictionary<Int, GameObject> {
        var gameObjectDictionary = Dictionary<Int, GameObject>()

        let gameObjectManagedObjectArray = self.diskController.loadGameObjectManagedObjectArray()
        for gameObjectManagedObject in gameObjectManagedObjectArray {
            let typeID = Int(gameObjectManagedObject.typeID)
            let id = Int(gameObjectManagedObject.id)
            let coordinate = GameObjectCoordinate(
                inventory: Int(gameObjectManagedObject.inventory),
                x: Int(gameObjectManagedObject.x),
                y: Int(gameObjectManagedObject.y))
            let gameObject = GameObject.new(ofTypeID: typeID, id: id, coordinate: coordinate)
            gameObjectDictionary[id] = gameObject
        }

        return gameObjectDictionary
    }

    func update(tileType: Int, toX x: Int, y: Int) {
        self.worldSceneTileModel.set(tileType: tileType, toX: x, y: y)

        var value = tileType
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.diskController.save(tileData: tileData, toX: x, y: y)
    }

    func add(_ gameObject: GameObject) {
        self.worldSceneGameObjectModel.add(gameObject)

        self.diskController.store(gameObject)
    }

    func remove(_ gameObject: GameObject) {
        self.worldSceneGameObjectModel.remove(gameObject)

        self.diskController.delete(gameObject)
    }

}

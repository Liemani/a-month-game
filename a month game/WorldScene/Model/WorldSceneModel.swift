//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

/// Control world scene model and DiskController
final class WorldSceneModel {

    let worldDataContainer: WorldDataContainer

    private var nextID: Int
    var tileMapModel: TileMapModel!

    var didChanged: Bool

    // MARK: - init
    init(worldDataContainer: WorldDataContainer) {
        self.worldDataContainer = worldDataContainer

        self.nextID = self.worldDataContainer.readNextID()

        let tileMapData = self.worldDataContainer.loadTileData()
        self.tileMapModel = TileMapModel(tileMapData: tileMapData)

        self.didChanged = false
    }

    func loadGOMOs() -> [GameObjectMO] {
        return self.worldDataContainer.loadGOMOs()
    }

    // MARK: - edit
    func update(tileType: Int, toX x: Int, y: Int) {
        self.tileMapModel.set(tileType: tileType, toX: x, y: y)

        var value = tileType
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.worldDataContainer.save(tileData: tileData, toX: x, y: y)
    }

    /// Call contextSave() manually
    func newGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObjectMO {
        let newGOMO = self.worldDataContainer.newGOMO()
        newGOMO.set(id: self.generateID(), gameObjectType: goType, goCoord: goCoord)
        self.didChanged = true
        return newGOMO
    }

    func setGOMO(_ goMO: GameObjectMO, to goCoord: GameObjectCoordinate) {
        goMO.set(to: goCoord)
        self.didChanged = true
    }

    func remove(_ goMO: GameObjectMO) {
        self.worldDataContainer.delete(goMO)
        self.didChanged = true
    }

    func contextSave() {
        if self.didChanged {
            self.worldDataContainer.contextSave()
        }
        self.didChanged = false
    }

    func generateID() -> Int {
        let id = self.nextID
        self.nextID += 1
        self.worldDataContainer.updateNextID(nextID: self.nextID)

        return id
    }

}

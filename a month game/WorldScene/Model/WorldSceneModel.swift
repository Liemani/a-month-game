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

    private var idGenerator: IDGenerator
    var tileMapModel: TileMapModel!

    var needContextSave: Bool

    // MARK: - init
    init(worldDataContainer: WorldDataContainer) {
        self.worldDataContainer = worldDataContainer

        self.idGenerator = IDGenerator(worldDataRepository: worldDataContainer.worldDataRepository)

        let tileMapData = self.worldDataContainer.tileService.loadTileMap()
        self.tileMapModel = TileMapModel(tileMapData: tileMapData)

        self.needContextSave = false
    }

    func loadGOMOs() -> [GameObjectMO] {
        return self.worldDataContainer.loadGOMOs()
    }

    // MARK: - edit
    /// Call contextSave() manually
    func newGOMO(of goType: GameObjectType, to goCoord: GameObjectCoordinate) -> GameObjectMO {
        let newGOMO = self.worldDataContainer.newGOMO()
        newGOMO.set(id: self.idGenerator.generate(), gameObjectType: goType, goCoord: goCoord)
        self.needContextSave = true
        return newGOMO
    }

    func setGOMO(_ goMO: GameObjectMO, to goCoord: GameObjectCoordinate) {
        goMO.set(to: goCoord)
        self.needContextSave = true
    }

    func remove(_ goMO: GameObjectMO) {
        self.worldDataContainer.delete(goMO)
        self.needContextSave = true
    }

    func contextSaveIfNeed() {
        guard self.needContextSave else { return }

        self.worldDataContainer.contextSave()
        self.needContextSave = false
    }

}

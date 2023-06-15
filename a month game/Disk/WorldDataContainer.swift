//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

final class WorldDataContainer {

    let worldDirectoryURL: URL

    let gameObjectRepository: GameObjectRepository
    let tileMapRepository: TileMapRepository
    let worldDataRepository: WorldDataRepository

    init(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)
        self.worldDirectoryURL = worldDirectoryURL

        WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        self.gameObjectRepository = GameObjectRepository(worldDirectoryURL: worldDirectoryURL)
        self.tileMapRepository = TileMapRepository(worldDirectoryURL: worldDirectoryURL)
        self.worldDataRepository = WorldDataRepository(worldDirectoryURL: worldDirectoryURL)
    }

    // MARK: - CoreData
    func newGOMO() -> GameObjectMO {
        return self.gameObjectRepository.newGOMO()
    }

    func loadGOMOs() -> [GameObjectMO] {
        return self.gameObjectRepository.fetchGOMOs()
    }

    func contextSave() {
        self.gameObjectRepository.contextSave()
    }

    func delete(_ goMO: GameObjectMO) {
        self.gameObjectRepository.delete(goMO)
    }

    // MARK: - FileManager
    func loadTileData() -> Data {
        return self.tileMapRepository.loadTileMapData()
    }

    func save(tileData: Data, toX x: Int, y: Int) {
        let index = Constant.gridSize * x + y
        self.tileMapRepository.save(tileData: tileData, toIndex: index)
    }

}

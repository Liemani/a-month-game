//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

final class WorldDataContainer {

    let worldDirectoryURL: URL

    let gameObjectService: GameObjectService
    let tileService: TileService
    let worldDataService: WorldDataService

    init(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)
        self.worldDirectoryURL = worldDirectoryURL

#if DEBUG
        print(worldDirectoryURL)
#endif

        WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        self.gameObjectService = GameObjectService(worldDirectoryURL: worldDirectoryURL)
        self.tileService = TileService(worldDirectoryURL: worldDirectoryURL)
        self.worldDataService = WorldDataService(worldDirectoryURL: worldDirectoryURL)
    }

    // MARK: - delegate
    // MARK: GameObjectService
    func newGOMO() -> GameObjectMO {
        return self.gameObjectService.newGOMO()
    }

    func loadGOMOs() -> [GameObjectMO] {
        return self.gameObjectService.load()
    }

    func contextSave() {
        self.gameObjectService.contextSave()
    }

    func delete(_ goMO: GameObjectMO) {
        self.gameObjectService.delete(goMO)
    }

}

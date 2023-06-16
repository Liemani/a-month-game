//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

final class WorldServiceContainer {

    let gameObjectService: GameObjectService
    let tileService: TileService
    let worldDataService: WorldDataService

    init(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        self.gameObjectService = GameObjectService(worldDirectoryURL: worldDirectoryURL)
        self.tileService = TileService(worldDirectoryURL: worldDirectoryURL)
        self.worldDataService = WorldDataService(worldDirectoryURL: worldDirectoryURL)

#if DEBUG
        print(worldDirectoryURL)
#endif
    }

}

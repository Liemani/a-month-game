//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

final class WorldRepositoryContainer {

    let goRepository: GameObjectRepository
    let chunkRepository: ChunkRepository
    let worldDataRepository: WorldDataRepository

    init(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        let isWorldExist = WorldDirectoryUtility.default.isExist(worldName: worldName)

        WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        let persistentContainer = LMIPersistentContainer(name: Constant.Name.worldDataModel)
        persistentContainer.setUp(to: worldDirectoryURL)

        self.goRepository = GameObjectRepository(persistentContainer: persistentContainer)
        self.chunkRepository = ChunkRepository(persistentContainer: persistentContainer)
        self.worldDataRepository = WorldDataRepository(worldDirectoryURL: worldDirectoryURL)

        if !isWorldExist {
            WorldGenerator.generate(worldDataContainer: self)
        }

#if DEBUG
        print(worldDirectoryURL)
#endif
    }

}

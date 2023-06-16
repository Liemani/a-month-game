//
//  GameObjectService.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation

class GameObjectService {

    private var gameObjectRepository: GameObjectRepository

    init(worldDirectoryURL: URL) {
        self.gameObjectRepository = GameObjectRepository(worldDirectoryURL: worldDirectoryURL)
    }

    func newGOMO(id: Int, type: GameObjectType, container: ContainerType, x: Int, y: Int) {
        self.newGOMO(id: id, type: type, container: container, chunkCoord: ChunkCoordinate(x, y))
    }

    func newGOMO(id: Int, type: GameObjectType, container: ContainerType, chunkCoord: ChunkCoordinate) {
        let mo = self.gameObjectRepository.newMO()

        mo.id = Int32(id)
        mo.typeID = Int32(type.rawValue)
        mo.containerID = Int32(container.rawValue)
        mo.chunkX = chunkCoord.chunkX
        mo.chunkY = chunkCoord.chunkY
        mo.chunkLocation = chunkCoord.chunkLocation
    }

    // MARK: - delegate
    func newGOMO() -> GameObjectMO {
        return self.gameObjectRepository.newMO()
    }

    func load() -> [GameObjectMO] {
        return self.gameObjectRepository.load()
    }

    func contextSave() {
        self.gameObjectRepository.contextSave()
    }

    func delete(_ goMO: GameObjectMO) {
        self.gameObjectRepository.delete(goMO)
    }

}

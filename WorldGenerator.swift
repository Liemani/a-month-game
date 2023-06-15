//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    private let worldDataContainer: WorldDataContainer
    private let idGenerator: IDGenerator

    static func generate(worldDataContainer: WorldDataContainer) {
        let worldGenerator = WorldGenerator(worldDataContainer: worldDataContainer)
        worldGenerator.generateGOMOs()
    }

    private init(worldDataContainer: WorldDataContainer) {
        self.worldDataContainer = worldDataContainer
        self.idGenerator = IDGenerator(worldDataRepository: worldDataContainer.worldDataRepository)
    }

    private func generateGOMOs() {
        self.newGOMO(typeID: 1, containerID: 0, x: Constant.centerTileIndex - 2, y: Constant.centerTileIndex - 3)
        self.newGOMO(typeID: 2, containerID: 0, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 3)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 1)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex + 1)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex, y: Constant.centerTileIndex + 1)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex + 1)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex)
        self.newGOMO(typeID: 3, containerID: 0, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 1)
        self.newGOMO(typeID: 4, containerID: 0, x: Constant.centerTileIndex, y: Constant.centerTileIndex - 3)
        self.newGOMO(typeID: 5, containerID: 0, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 3)

        self.worldDataContainer.contextSave()
    }

    private func newGOMO(typeID: Int32, containerID: Int32, x: Int, y: Int) {
        let chunkCoord = ChunkCoordinate(x, y)
        self.newGOMO(typeID: typeID, containerID: containerID, chunkX: Int32(chunkCoord.chunkX), chunkY: Int32(chunkCoord.chunkY), chunkLocation: chunkCoord.chunkLocation)
    }

    private func newGOMO(typeID: Int32, containerID: Int32, chunkX: Int32, chunkY: Int32, chunkLocation: Int16) {
        let managedObject = self.worldDataContainer.newGOMO()

        managedObject.typeID = typeID
        managedObject.id = Int32(self.idGenerator.generate())
        managedObject.containerID = containerID
        managedObject.chunkX = chunkX
        managedObject.chunkY = chunkY
        managedObject.chunkLocation = chunkLocation
    }

}

//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    private let serviceContainer: WorldServiceContainer
    private let idGenerator: IDGenerator

    static func generate(worldDataContainer: WorldServiceContainer) {
        let worldGenerator = WorldGenerator(worldDataContainer: worldDataContainer)
        worldGenerator.generateWorldData()
        worldGenerator.generateGOMOs()
        worldGenerator.generateTileMapData()
    }

    private init(worldDataContainer: WorldServiceContainer) {
        self.serviceContainer = worldDataContainer
        self.idGenerator = IDGenerator(worldDataService: worldDataContainer.worldDataService)
    }

    private func generateWorldData() {
        self.serviceContainer.worldDataService.update(value: Constant.initialNextID, to: .nextID)
        self.serviceContainer.worldDataService.update(value: 0, to: .characterX)
        self.serviceContainer.worldDataService.update(value: 0, to: .characterY)
    }

    private func generateGOMOs() {
        self.newGOMO(type: .pineCone, container: .field, x: 0, y: 0)
        self.newGOMO(type: .pineCone, container: .field, x: Constant.centerTileIndex - 2, y: Constant.centerTileIndex - 3)
        self.newGOMO(type: .pineTree, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 3)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex + 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex, y: Constant.centerTileIndex + 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex + 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 1)
        self.newGOMO(type: .branch, container: .field, x: Constant.centerTileIndex, y: Constant.centerTileIndex - 3)
        self.newGOMO(type: .stone, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 3)

        self.serviceContainer.gameObjectService.contextSave()
    }

    private func generateTileMapData() {
        self.serviceContainer.tileService.update(type: .woodFloor, toX: Constant.centerTileIndex, y: Constant.centerTileIndex)
    }

    private func newGOMO(type: GameObjectType, container: ContainerType, x: Int, y: Int) {
        self.serviceContainer.gameObjectService.newGOMO(id: self.idGenerator.generate(), type: type, container: container, x: x, y: y)
    }

}

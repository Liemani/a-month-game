//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    private let serviceContainer: WorldRepositoryContainer
    private let idGenerator: IDGenerator

    static func generate(worldDataContainer: WorldRepositoryContainer) {
        let worldGenerator = WorldGenerator(worldDataContainer: worldDataContainer)
        worldGenerator.generateWorldData()
        worldGenerator.generateGOMOs()
        worldGenerator.generateTileMapData()
    }

    private init(worldDataContainer: WorldRepositoryContainer) {
        self.serviceContainer = worldDataContainer
        self.idGenerator = IDGenerator(worldDataRepository: worldDataContainer.worldDataRepository)
    }

    private func generateWorldData() {
        self.serviceContainer.worldDataRepository.update(value: Constant.initialNextID, to: .nextID)
        self.serviceContainer.worldDataRepository.update(value: 0, to: .characterPositionX)
        self.serviceContainer.worldDataRepository.update(value: 0, to: .characterPositionY)
    }

    private func generateGOMOs() {
        self.new(type: .pineCone, x: 0, y: 0)
        self.new(type: .woodWall, x: 2, y: 2)
        self.new(type: .woodWall, x: 2, y: 3)
        self.new(type: .woodWall, x: 2, y: 4)
        self.new(type: .woodWall, x: 3, y: 4)
        self.new(type: .woodWall, x: 4, y: 4)
        self.new(type: .woodWall, x: 4, y: 3)
        self.new(type: .woodWall, x: 4, y: 2)
        self.new(type: .pineCone, x: Constant.centerTileIndex - 2, y: Constant.centerTileIndex - 3)
        self.new(type: .pineTree, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 3)
        self.new(type: .woodWall, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 1)
        self.new(type: .woodWall, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex)
        self.new(type: .woodWall, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex + 1)
        self.new(type: .woodWall, x: Constant.centerTileIndex, y: Constant.centerTileIndex + 1)
        self.new(type: .woodWall, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex + 1)
        self.new(type: .woodWall, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex)
        self.new(type: .woodWall, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 1)
        self.new(type: .branch, x: Constant.centerTileIndex, y: Constant.centerTileIndex - 3)
        self.new(type: .stone, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 3)

        self.serviceContainer.goRepository.contextSave()
    }

    private func generateTileMapData() {
        self.serviceContainer.tileRepository.update(type: .woodFloor, toX: Constant.centerTileIndex, y: Constant.centerTileIndex)
    }

    private func new(type: GameObjectType, x: Int, y: Int) {
        let id = self.idGenerator.generate()
        _ = self.serviceContainer.goRepository.new(id: id, type: type, coord: Coordinate(x, y))
    }

}

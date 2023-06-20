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

    #warning("what about create file here?")
    static func generate(worldDataContainer: WorldRepositoryContainer) {
        let worldGenerator = WorldGenerator(worldDataContainer: worldDataContainer)
        worldGenerator.generateWorldData()
        worldGenerator.generateGOMOs()
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
        self.new(type: .woodFloor, x: 0, y: 0)

        self.new(type: .woodWall, x: -1, y: -1)
        self.new(type: .woodWall, x: -1, y: 0)
        self.new(type: .woodWall, x: -1, y: 1)
        self.new(type: .woodWall, x: 0, y: 1)
        self.new(type: .woodWall, x: 1, y: 1)
        self.new(type: .woodWall, x: 1, y: 0)
        self.new(type: .woodWall, x: 1, y: -1)

        self.serviceContainer.goRepository.contextSave()
    }

    private func new(type: GameObjectType, x: Int, y: Int) {
        let id = self.idGenerator.generate()
        _ = self.serviceContainer.goRepository.new(id: id, type: type, coord: Coordinate(x, y))
    }

}

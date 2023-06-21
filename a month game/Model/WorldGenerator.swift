//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    private let worldServiceContainer: WorldServiceContainer
    private let idGenerator: IDGeneratorService

    static func generate(_ worldServiceContainer: WorldServiceContainer) {
        let worldGenerator = WorldGenerator(worldServiceContainer)
        worldGenerator.generateWorldData()
        worldGenerator.generateGOMOs()
    }

    private init(_ worldServiceContainer: WorldServiceContainer) {
        self.worldServiceContainer = worldServiceContainer
        self.idGenerator = IDGeneratorService(worldServiceContainer)
    }

    private func generateWorldData() {
        let worldDataRep = self.worldServiceContainer.worldDataRepository!
        worldDataRep.update(value: Constant.initialNextID, to: .nextID)
        worldDataRep.update(value: -1, to: .characterLocationChunkX)
        worldDataRep.update(value: -1, to: .characterLocationChunkY)
        worldDataRep.update(value: -2, to: .characterLocationChunkLocation)
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

        try! self.worldServiceContainer.moContext.save()
    }

    private func new(type: GameObjectType, x: Int, y: Int) {
        let id = self.idGenerator.generate()
        let goMO = self.worldServiceContainer.goRepository.new(id: id, type: type)
        let chunkCoord = ChunkCoordinate(from: Coordinate(x, y))
        goMO.update(to: chunkCoord)
    }

}

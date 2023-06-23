//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    static func generate() {
        let worldGenerator = WorldGenerator()
        worldGenerator.generateWorldData()
        worldGenerator.generateGOMOs()
    }

    private func generateWorldData() {
        let worldDataRepo = WorldServiceContainer.default.worldDataRepo
        worldDataRepo.update(value: Constant.initialNextID, to: .nextID)
        worldDataRepo.update(value: 0, to: .characterLocationChunkX)
        worldDataRepo.update(value: 0, to: .characterLocationChunkY)
        worldDataRepo.update(value: 0, to: .characterLocationChunkLocation)
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

        try! WorldServiceContainer.default.moContext.save()
    }

    private func new(type: GameObjectType, x: Int, y: Int) {
        let id = WorldServiceContainer.default.idGeneratorServ.generate()
        let goMO = WorldServiceContainer.default.goRepo.new(id: id, type: type)
        let chunkCoord = ChunkCoordinate(from: Coordinate(x, y))
        goMO.update(to: chunkCoord)
    }

}

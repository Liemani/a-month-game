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
        self.new(type: .woodFloorTile, x: 0, y: 0)

        self.new(type: .woodWall, x: -1, y: -1)
        self.new(type: .woodWall, x: -1, y: 0)
        self.new(type: .woodWall, x: -1, y: 1)
        self.new(type: .woodWall, x: 0, y: 1)
        self.new(type: .woodWall, x: 1, y: 1)
        self.new(type: .woodWall, x: 1, y: 0)
        self.new(type: .woodWall, x: 1, y: -1)

        for x in 0...20 {
            self.new(type: .stone, x: x, y: -3)
            self.new(type: .woodStick, x: x, y: -4)
        }

        for x in -20 ... -5 {
            self.generateTerrain(x, 0)
        }

        try! WorldServiceContainer.default.moContext.save()
    }

    private func generateTerrain(_ x: Int, _ y: Int) {
        self.new(type: .clayTile, x: x + 0, y: y + 0)
        self.new(type: .dirtTile, x: x + 0, y: y + 1)
        self.new(type: .sandTile, x: x + 0, y: y + 2)
        self.new(type: .caveCeilTile, x: x + 0, y: y + 3)
        self.new(type: .caveHoleTile, x: x + 0, y: y + 4)
        self.new(type: .cobblestoneTile, x: x + 0, y: y + 5)
        self.new(type: .waterTile, x: x + 0, y: y + 6)
    }

    private func new(type: GameObjectType, x: Int, y: Int) {
        let id = WorldServiceContainer.default.idGeneratorServ.generate()
        let goMO = WorldServiceContainer.default.goRepo.new(id: id, type: type)
        let chunkCoord = ChunkCoordinate(x, y)
        goMO.update(to: chunkCoord)
    }

}

//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    static func generate(worldName: String) {
        FileUtility.default.createCharacterDirIfNotExist()

        if (!FileUtility.default.isWorldDirExist(worldName: worldName)) {
            Services.set(worldName: worldName)

            let worldGenerator = WorldGenerator()
            worldGenerator.generateWorldData(worldName: worldName)
            worldGenerator.generateGOMOs()
        }
    }

    private func generateWorldData(worldName: String) {
        let worldDataRepo = Services.default.worldDataRepo

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

        for x in -20 ... -5 {
            self.generateTerrain(x, 0)
        }

        self.newSquare(goType: .treeOak, x: 0, y: 5, width: 5, height: 5)
        self.newSquare(goType: .weed, x: 5, y: 5, width: 5, height: 5)
        self.newSquare(goType: .vine, x: 0, y: 10, width: 5, height: 5)

        try! Services.default.moContext.save()
    }

    func newSquare(goType: GameObjectType, x: Int, y: Int, width: Int, height: Int) {
        for x in x ..< x + width {
            for y in y ..< y + width {
                self.new(type: goType, x: x, y: y)
            }
        }
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

    private func new(type goType: GameObjectType, x: Int, y: Int) {
        let id = Services.default.idGeneratorServ.generate()
        let goMO = Services.default.goRepo.new(id: id,
                                                       type: goType,
                                                       variant: 0,
                                                       quality: 0.0,
                                                       state: [])
        let chunkCoord = ChunkCoordinate(x, y)
        goMO.update(to: chunkCoord)
    }

}

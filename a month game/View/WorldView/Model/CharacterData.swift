//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

struct CharacterData {

    var chunkCoord: ChunkCoordinate
    var buildingPosition: CGPoint {
        let x = Int(self.chunkCoord.buildingX)
        let y = Int(self.chunkCoord.buildingY)
        let coord = Coordinate(x, y)
        let tileCoord = TileCoordinate(coord)
        return tileCoord.fieldPoint
    }

    // MARK: - init
    init() {
        let worldDataRep = WorldServiceContainer.default.worldDataRepo

        let chunkX = worldDataRep.load(at: .characterLocationChunkX)
        let chunkY = worldDataRep.load(at: .characterLocationChunkY)
        let chunkLocation = worldDataRep.load(at: .characterLocationChunkLocation)

        self.chunkCoord = ChunkCoordinate(x: chunkX, y: chunkY, location: chunkLocation)
    }

    func update(chunkCoord: ChunkCoordinate) {
        let worldDataRep = WorldServiceContainer.default.worldDataRepo

        worldDataRep.update(value: Int(chunkCoord.x), to: .characterLocationChunkX)
        worldDataRep.update(value: Int(chunkCoord.y), to: .characterLocationChunkY)
        worldDataRep.update(value: Int(chunkCoord.location), to: .characterLocationChunkLocation)
    }

}

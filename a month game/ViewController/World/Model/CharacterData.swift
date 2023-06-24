//
//  CharacterController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

struct CharacterData {

    private var _chunkCoord: ChunkCoordinate
    var chunkCoord: ChunkCoordinate {
        get { self._chunkCoord }
        set {
            self._chunkCoord = newValue
            self.update(chunkCoord: newValue)
        }
    }

    var buildingCoord: Coordinate<Int> {
        let x = self.chunkCoord.street.building.coordX
        let y = self.chunkCoord.street.building.coordY
        let coord = Coordinate(x, y)
        return coord
    }

    // MARK: - init
    init() {
        let worldDataRep = WorldServiceContainer.default.worldDataRepo

        let x = worldDataRep.load(at: .characterLocationChunkX)
        let y = worldDataRep.load(at: .characterLocationChunkY)
        let streetAddress = worldDataRep.load(at: .characterLocationChunkLocation)

        self._chunkCoord = ChunkCoordinate(x: Int32(truncatingIfNeeded: x),
                                           y: Int32(truncatingIfNeeded: y),
                                           streetAddress: UInt16(truncatingIfNeeded: streetAddress))
    }

    private func update(chunkCoord: ChunkCoordinate) {
        let worldDataRep = WorldServiceContainer.default.worldDataRepo

        worldDataRep.update(value: Int(chunkCoord.x), to: .characterLocationChunkX)
        worldDataRep.update(value: Int(chunkCoord.y), to: .characterLocationChunkY)
        worldDataRep.update(value: Int(chunkCoord.street.address), to: .characterLocationChunkLocation)
    }

}

//
//  ChunkContainerService.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/20.
//

import Foundation
import SpriteKit

class ChunkContainerService {

    let target: ChunkContainer

    var lowerBound: Coordinate<Int> {
        let middleChunkChunkCoord = Services.default.character.chunkCoord.chunk.coord
        return middleChunkChunkCoord + Direction9.southWest.coordOfAChunk
    }
    var upperBound: Coordinate<Int> {
        let middleChunkChunkCoord = Services.default.character.chunkCoord.chunk.coord
        return middleChunkChunkCoord + Direction9.northEast.coordOfAChunk * 2
    }

    var originCoordInWorld: Coordinate<Int> {
        let middleCoordInWorld = Services.default.character.chunkCoord.chunk.coord
        let originOffset = Direction9.southWest.coord * Constant.tileCountOfChunkSide
        return middleCoordInWorld + originOffset
    }

    func coord(_ chunkCoord: ChunkCoordinate) -> Coordinate<Int> {
        return chunkCoord.coord - self.originCoordInWorld
    }

    func coord(_ coordInWorld: Coordinate<Int>) -> Coordinate<Int> {
        return coordInWorld - self.originCoordInWorld
    }

    func chunkCoord(_ coord: Coordinate<Int>) -> ChunkCoordinate {
        let coordInWorld = coord + self.originCoordInWorld
        return ChunkCoordinate(coordInWorld)
    }

    // MARK: - init
    init() {
        self.target = ChunkContainer()
    }

    func setUp() {
        let middleChunkChunkCoord = Services.default.character.chunkCoord

        for (index, chunk) in self.target.chunks.enumerated() {
            let direction = Direction9(rawValue: index)!
            let chunkChunkCoord = middleChunkChunkCoord.to(direction)

            chunk.setUp(chunkCoord: chunkChunkCoord)
        }
    }

    func update() {
        if let direction = Services.default.character.movedChunkDirection {
            self._update(direction4: direction)
        } else {
            self.reset()
        }
    }

    private func _update(direction4: Direction4) {
        self.target.chunks.shift(direction: direction4.opposite)

        let middleChunkChunkCoord = Services.default.character.chunkCoord.chunk

        for direction in direction4.direction9 {
            let chunkChunkCoord = middleChunkChunkCoord.to(direction)
            let chunk = self.target.chunk(containing: self.coord(chunkChunkCoord))
            
            chunk.update(chunkCoord: chunkChunkCoord)
        }
    }

    func reset() {
        self.target.removeAll()
        self.setUp()
    }

    func items(at chunkCoord: ChunkCoordinate) -> [GameObject]? {
        return self.target.items(at: self.coord(chunkCoord))
    }

    func item(at chunkCoord: ChunkCoordinate) -> GameObject? {
        let coord = self.coord(chunkCoord)
        return self.target.items(at: coord)?.first
    }

    func add(_ go: GameObject) {
        self.target.add(go, to: self.coord(go.chunkCoord!))

        let characterCoord = Services.default.character.chunkCoord.coord

        if !go.type.isWalkable
            && go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
            Logics.default.accessibleGOTracker.add(go)
        }
    }

}

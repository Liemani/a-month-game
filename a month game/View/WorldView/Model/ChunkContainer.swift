//
//  ChunkModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class ChunkContainer {

    private let chunkRepository: ChunkRepository
    private let goRepository: GameObjectRepository

    var middleChunkCoord: Coordinate<Int>
    var chunks: [Chunk]

    init(chunkRepository: ChunkRepository, goRepository: GameObjectRepository) {
        self.chunkRepository = chunkRepository
        self.goRepository = goRepository
        self.middleChunkCoord = Coordinate(0, 0)
        let emptyChunk = Chunk(chunkRepository: chunkRepository, goRepository: goRepository)
        self.chunks = [Chunk](repeating: emptyChunk, count: 9)
    }

    var fieldGOs: [GameObject] {
        print("chunks count: \(self.chunks.count)")
        for chunk in self.chunks {
            print("    chunk count: \(chunk.gos.count)")
        }
        return self.chunks.flatMap { $0.gos }
    }

    // MARK: - chunk
    func setUp(coord: Coordinate<Int>) {
        for direction in Direction9.allCases {
            let targetCoord = coord + direction.coord

            let chunk = Chunk(chunkRepository: self.chunkRepository, goRepository: self.goRepository, coord: targetCoord)
            self.chunks[direction] = chunk
        }
        self.middleChunkCoord = coord
    }

    func update(coord: Coordinate<Int>, direction: Direction4) {
        self.shift(direction: direction.opposite)

        for direction in direction.direction8 {
            let targetTileCoord = coord + direction.coord
            let chunk = Chunk(chunkRepository: self.chunkRepository, goRepository: self.goRepository, coord: targetTileCoord)
            self.chunks[direction] = chunk
        }
        self.middleChunkCoord = coord
    }

    // MARK: - game object
    func update(_ go: GameObject, to coord: Coordinate<Int>) {
        if let goCoord = go.coord {
            self.remove(go, from: goCoord)
        }
        self.add(go, to: coord)
    }

    func remove(_ go: GameObject, from coord: Coordinate<Int>) {
        let chunkDirection = ChunkCoordinate.buildingDirection(from: self.middleChunkCoord, to: coord)!
        self.chunks[chunkDirection][go.id] = nil
    }

    private func shift(direction: Direction4) {
        switch direction {
        case .East:
            self.chunks[2] = self.chunks[1]
            self.chunks[1] = self.chunks[0]
            self.chunks[5] = self.chunks[4]
            self.chunks[4] = self.chunks[3]
            self.chunks[8] = self.chunks[7]
            self.chunks[7] = self.chunks[6]
        case .South:
            self.chunks[0] = self.chunks[3]
            self.chunks[1] = self.chunks[4]
            self.chunks[2] = self.chunks[5]
            self.chunks[3] = self.chunks[6]
            self.chunks[4] = self.chunks[7]
            self.chunks[5] = self.chunks[8]
        case .West:
            self.chunks[0] = self.chunks[1]
            self.chunks[1] = self.chunks[2]
            self.chunks[3] = self.chunks[4]
            self.chunks[4] = self.chunks[5]
            self.chunks[6] = self.chunks[7]
            self.chunks[7] = self.chunks[8]
        case .North:
            self.chunks[6] = self.chunks[3]
            self.chunks[7] = self.chunks[4]
            self.chunks[8] = self.chunks[5]
            self.chunks[3] = self.chunks[0]
            self.chunks[4] = self.chunks[1]
            self.chunks[5] = self.chunks[2]
        }
    }

    private func add(_ go: GameObject, to coord: Coordinate<Int>) {
        let chunkDirection = ChunkCoordinate.buildingDirection(from: self.middleChunkCoord, to: coord)!
        self.chunks[chunkDirection][go.id] = go
    }

}

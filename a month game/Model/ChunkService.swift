//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class ChunkService {

    private let chunkRepo: ChunkRepository

    init(chunkRepo: ChunkRepository) {
        self.chunkRepo = chunkRepo
    }

    /// - Parameters:
    ///         - chunkCoord: ChunkCoordinate of chunk
    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectData] {
        var goMOs: [GameObjectMO]

        if Services.default.chunkIsGeneratedDS.load(at: chunkCoord).isEmpty {
            goMOs = MapGenerator.default.generateChunk(chunkCoord)
        } else {
            goMOs = self.chunkRepo.load(at: chunkCoord)
        }

        let goDatas = goMOs.compactMap { GameObjectData(from: $0) }
        return goDatas
    }

}

//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class ChunkService {

    /// - Parameters:
    ///         - chunkCoord: ChunkCoordinate of chunk
    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectData] {
        let chunkChunkCoord = chunkCoord.chunk

        var goMOs: [GameObjectMO]

        if Repositories.default.chunkIsGeneratedDS.load(at: chunkChunkCoord).isEmpty {
            goMOs = MapGenerator.default.generateChunk(chunkChunkCoord)
        } else {
            goMOs = Repositories.default.chunkRepo.load(at: chunkChunkCoord)
        }

        let goDatas = goMOs.compactMap { GameObjectData(from: $0) }
        return goDatas
    }

}

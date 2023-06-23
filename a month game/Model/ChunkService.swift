//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class ChunkService {

    private var chunkRepository: ChunkRepository!

    init(chunkRepository: ChunkRepository) {
        self.chunkRepository = chunkRepository
    }

    func load(at chunkCoord: ChunkCoordinate) -> [GameObjectData] {
        let goMOs = self.chunkRepository.load(at: chunkCoord)
        let goDatas = goMOs.compactMap {
            GameObjectData(from: $0)
        }
        return goDatas
    }

}

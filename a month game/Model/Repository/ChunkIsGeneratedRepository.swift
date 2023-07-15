//
//  ChunkIsGeneratedRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/15.
//

import Foundation
import CoreData

class ChunkIsGeneratedRepository {

    private let chunkIsGeneratedDS: ChunkIsGeneratedDataSource

    typealias MOType = ChunkIsGeneratedMO

    init(chunkIsGeneratedDS: ChunkIsGeneratedDataSource) {
        self.chunkIsGeneratedDS = chunkIsGeneratedDS
    }

    func new(chunkCoord: ChunkCoordinate) {
        let mo = self.chunkIsGeneratedDS.new()

        mo.x = chunkCoord.x
        mo.y = chunkCoord.y
        mo.address = Int32(chunkCoord.address.value)
    }

}

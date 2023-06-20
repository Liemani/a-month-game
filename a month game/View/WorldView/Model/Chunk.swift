//
//  Chunk.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/18.
//

import Foundation

class Chunk {

    private var chunkRepository: ChunkRepository!
    private var goRepository: GameObjectRepository!

    private let dict: NSMutableDictionary
    var gos: [GameObject] { self.dict.allValues as! [GameObject] }

    var chunkCoord: ChunkCoordinate!

    init(chunkRepository: ChunkRepository, goRepository: GameObjectRepository) {
        self.chunkRepository = chunkRepository
        self.goRepository = goRepository
        self.dict = NSMutableDictionary()
    }

    init(chunkRepository: ChunkRepository, goRepository: GameObjectRepository, coord: Coordinate<Int>) {
        self.chunkRepository = chunkRepository
        self.goRepository = goRepository

        let goMOs = chunkRepository.load(at: coord)
        let dict = NSMutableDictionary(capacity: goMOs.count)

        let keyValuePairs = goMOs.map({ ($0.id, GameObject(goRepository: goRepository, from: $0)) })
        for (key, value) in keyValuePairs {
            dict[key] = value
        }

        self.dict = dict

        let chunkCoord = ChunkCoordinate(from: coord)
    }

    subscript(key: Int) -> GameObject? {
        get { self.dict[key] as! GameObject? }
        set { self.dict[key] = newValue }
    }

}

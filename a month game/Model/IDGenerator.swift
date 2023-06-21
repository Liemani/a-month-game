//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class IDGeneratorService {

    private var worldDataRepository: WorldDataRepository
    private var nextID: Int

    init(worldDataRepository: WorldDataRepository) {
        self.worldDataRepository = worldDataRepository

        let nextID = self.worldDataRepository.load(at: .nextID)
        self.nextID = nextID
    }

    func generate() -> Int {
        let id = self.nextID
        self.nextID += 1
        self.worldDataRepository.update(value: nextID, to: .nextID)

        return id
    }

}

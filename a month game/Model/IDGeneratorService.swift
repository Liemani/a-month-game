//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class IDGeneratorService {

    private var worldDataRepository: WorldDataRepository
    lazy var nextID: Int = self.worldDataRepository.load(at: .nextID)

    init(worldDataRepository: WorldDataRepository) {
        self.worldDataRepository = worldDataRepository
    }

    func generate() -> Int {
        let id = self.nextID
        self.nextID += 1
        self.worldDataRepository.update(value: nextID, to: .nextID)

        return id
    }

}

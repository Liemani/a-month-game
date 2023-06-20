//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class IDGenerator {

    private var worldDataRepository: WorldDataRepository
    private var nextID: Int

    init(worldDataRepository: WorldDataRepository) {
        self.worldDataRepository = worldDataRepository
        self.nextID = 0

        self.nextID = self.readNextID()
    }

    func generate() -> Int {
        let id = self.nextID
        self.nextID += 1
        self.updateNextID(nextID: self.nextID)

        return id
    }

}

// MARK: - private
extension IDGenerator {

    private func readNextID() -> Int {
        return self.worldDataRepository.load(at: .nextID)
    }

    private func updateNextID(nextID: Int) {
        self.worldDataRepository.update(value: nextID, to: .nextID)
    }

}

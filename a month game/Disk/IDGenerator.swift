//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

class IDGenerator {

    var worldDataRepository: WorldDataRepository
    var nextID: Int

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

    // MARK: - WorldDataRepository
    private func readNextID() -> Int {
        let nextIDData = self.worldDataRepository.read(index: 0)
        return nextIDData.withUnsafeBytes { $0.load(as: Int.self) }
    }

    private func updateNextID(nextID: Int) {
        var nextID = nextID
        let data = Data(bytes: &nextID, count: MemoryLayout<Int>.size)
        self.worldDataRepository.update(data: data, index: 0)
    }
}

//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class IDGeneratorService {

    var nextID: Int

    init() {
        self.nextID = Repositories.default.worldDataRepo.load(at: .nextID)
    }

    func generate() -> Int {
        let id = self.nextID
        self.nextID += 1
        Repositories.default.worldDataRepo.update(value: nextID, to: .nextID)

        return id
    }

}

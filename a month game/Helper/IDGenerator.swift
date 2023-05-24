//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/16.
//

import Foundation

class IDGenerator {

    static var `default` = IDGenerator()

    private let diskController: DiskController

    private var nextID: Int

    init() {
        let diskController = DiskController.default
        self.diskController = diskController

        self.nextID = diskController.readUserDefaults(forKey: Constant.idGenerator)
    }

    static func generate() -> Int {
        self.default.generate()
    }

    private func generate() -> Int {
        let id = self.nextID
        self.nextID += 1
        self.diskController.updateUserDefaults(self.nextID, forKey: Constant.idGenerator)

        return id
    }

}

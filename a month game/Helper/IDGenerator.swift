//
//  IDGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/16.
//

import Foundation

class IDGenerator {

    static private var _default: IDGenerator?
    static var `default`: IDGenerator {
        get {
            if let idGenerator = IDGenerator._default {
                return idGenerator
            }
            let idGenerator = IDGenerator()
            IDGenerator._default = idGenerator
            return idGenerator
        }
    }

    private let diskController: DiskController

    private var nextID: Int

    init() {
        let diskController = DiskController.default
        self.diskController = diskController

        self.nextID = diskController.readUserDefaults(forKey: Constant.idGenerator)
    }

    func generate() -> Int {
        let id = self.nextID
        self.nextID += 1
        self.diskController.updateUserDefaults(self.nextID, forKey: Constant.idGenerator)

        return id
    }

}

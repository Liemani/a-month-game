//
//  WorldUpdateManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation

struct UpdateOptionSet : OptionSet {

    let rawValue: Int

    static let interaction = UpdateOptionSet(rawValue: 0x1 << 0)
    static let craftWindow = UpdateOptionSet(rawValue: 0x1 << 1)

}

class WorldUpdateManager {

    private static var _default: WorldUpdateManager?
    static var `default`: WorldUpdateManager { self._default! }

    static func set() { self._default = WorldUpdateManager() }
    static func free() { self._default = nil }

    private var updateOptionSet: UpdateOptionSet

    init() {
        self.updateOptionSet = []
    }

    func contains(_ member: UpdateOptionSet.Element) -> Bool {
        return self.updateOptionSet.contains(member)
    }

    func update(with newMember: UpdateOptionSet.Element) {
        self.updateOptionSet.update(with: newMember)
    }

    func subtract(_ member: UpdateOptionSet.Element) {
        self.updateOptionSet.subtract(member)
    }

}

//
//  ChunkScheduler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/17.
//

import Foundation

class ChunkGOScheduler {
    
    var orderedSet: NSMutableOrderedSet
    var hasChanges: Bool

    init() {
        self.orderedSet = NSMutableOrderedSet()
        self.hasChanges = false
    }

    func add(_ go: GameObject) {
        guard go.timeEventDate != nil else {
            return
        }

        self._add(go)

        self.hasChanges = true
    }

    private func _add(_ go: GameObject) {
        let count = self.orderedSet.count

        for index in 0 ..< count {
            let orderedGO = self.orderedSet[index] as! GameObject

            if go.timeEventDate! <= orderedGO.timeEventDate! {
                self.orderedSet.insert(go, at: index)
                return
            }
        }

        self.orderedSet[count] = go
    }

    func add(_ gos: [GameObject]) {
        self.orderedSet.addObjects(from: gos)
    }

    func remove(_ go: GameObject) {
        self.orderedSet.remove(go)

        self.hasChanges = true
    }

    func removeAll() {
        self.orderedSet.removeAllObjects()
    }

    func sort() {
        self.orderedSet.sort {
            let lhs = $0 as! GameObject
            let rhs = $1 as! GameObject

            return (lhs.timeEventDate! <= rhs.timeEventDate!)
                        ? .orderedAscending
                        : .orderedDescending
        }

        self.hasChanges = false
    }
    
}

//
//  ChunkScheduler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/17.
//

import Foundation

class ChunkScheduler {
    
    var orderedSet: NSMutableOrderedSet

    init() {
        self.orderedSet = NSMutableOrderedSet()
    }

    func add(_ go: GameObject) {
        let count = self.orderedSet.count

        if count == 0 {
            self.orderedSet[0] = go
            return
        }

        for index in 0 ..< count {
            let setGO = self.orderedSet[index] as! GameObject

            if go.scheduledDate <= setGO.data.scheduledDate {
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
    }

    func removeAll() {
        self.orderedSet.removeAllObjects()
    }

    func sort() {
        orderedSet.sort {
            let lhs = $0 as! GameObject
            let rhs = $1 as! GameObject

            return lhs.scheduledDate <= rhs.scheduledDate
                ? .orderedAscending
                : .orderedDescending
        }

    }
    
}

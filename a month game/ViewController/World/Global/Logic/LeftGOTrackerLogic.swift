//
//  LeftGOTrackerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/17.
//

import Foundation

class LeftGOTrackerLogic {

    let tracker: LeftGOTracker

    init(tracker: LeftGOTracker) {
        self.tracker = tracker
    }

    func addIfDisappearable(_ go: GameObject) {
        if go.type.isPickable && !go.type.isContainer {
            self.tracker.add(go)
        }
    }

    func remove(_ go: GameObject) {
        self.tracker.remove(go)
    }

    func update() {
        let removeDate = Date() - Constant.timeTookTooRemove

        for go in self.tracker {
            if go.dateLastChanged <= removeDate {
                self.tracker.remove(go)
                go.delete()
            }
        }
    }

}

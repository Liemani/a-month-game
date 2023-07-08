//
//  AccessibleGOTrackerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation

class AccessibleGOTrackerLogic {

    private let tracker: AccessibleGOTracker

    init(tracker: AccessibleGOTracker) {
        self.tracker = tracker
    }

    func add(_ go: GameObject) {
        self.tracker.add(go)
    }

    func remove(_ go: GameObject) {
        self.tracker.remove(go)
    }

}

//
//  PinchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PinchHandler {

    var trackingTouches: Set<LMITouch>
    var touches: [LMITouch]

    init() {
        self.trackingTouches = Set<LMITouch>()
        self.touches = []
    }

}

extension PinchHandler: TouchHandler {

    func discriminate(touch: LMITouch) -> Bool {
        if !self.trackingTouches.contains(touch) {
            self.trackingTouches.insert(touch)
        }

        guard self.trackingTouches.count >= 2 else {
            return false
        }

        let touches = self.touches
        if touches[0].touch.timestamp == touches[1].touch.timestamp {
            print("same")
        } else {
            print("not same")
        }

        return false
    }

    func removeFromTracking(touch: LMITouch) {
        self.trackingTouches.remove(touch)
    }

    func began(touches: [LMITouch]) {

    }

    func moved() {

    }

    func ended() {
        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {

    }

}

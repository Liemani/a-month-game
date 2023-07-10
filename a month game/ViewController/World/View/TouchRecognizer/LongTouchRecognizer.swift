//
//  LongTouchRecognizer.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation
import SpriteKit

class LongTouchRecognizer {

    var lmiTouches: [LMITouch] {
        return []
    }

}

extension LongTouchRecognizer: TouchRecognizer {

    func discriminate(lmiTouches: [LMITouch]) -> Bool {
        let lmiTouch = lmiTouches[0]

        guard lmiTouch.possible.contains(.longTouch) else {
            return false
        }

        let touchResponder = lmiTouch.touchResponder

        if touchResponder == nil || !touchResponder!.isBeing(touched: lmiTouch.touch) {
            lmiTouch.possible.remove(.tap)

            return false
        }

        let touchedDuration = lmiTouch.touch.timestamp - lmiTouch.bTime

        return touchedDuration >= Constant.longTouchThreshold
    }

    func began(lmiTouches: [LMITouch]) {
        let lmiTouch = lmiTouches[0]

        lmiTouch.setRecognizer(self)

        // remove time event

        lmiTouch.touchResponder!.longTouched(lmiTouch.touch)
    }

    func moved() {
    }

    func ended() {
    }

    func cancelled() {
    }

}

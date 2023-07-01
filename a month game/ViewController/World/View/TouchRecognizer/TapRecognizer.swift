//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class TapRecognizer {

    var lmiTouch: LMITouch?
    var lmiTouches: [LMITouch] {
        if let lmiTouch = self.lmiTouch {
            return [lmiTouch]
        } else {
            return []
        }
    }

    var touchResponder: TouchResponder?

    private let scene: WorldScene

    // MARK: - init
    init(scene: WorldScene) {
        self.scene = scene
    }

}

extension TapRecognizer: TouchRecognizer {

    func discriminate(lmiTouches: [LMITouch]) -> Bool {
        let lmiTouch = lmiTouches[0]

        guard lmiTouch.possible.contains(.tap) else {
            return false
        }

        if lmiTouch.touchResponder == nil {
            lmiTouch.possible.remove(.tap)

            return false
        }

        return true
    }

    func began(lmiTouches: [LMITouch]) {
        print("tap began")

        let lmiTouch = lmiTouches[0]
        self.lmiTouch = lmiTouch

        self.touchResponder = lmiTouch.touchResponder
        self.touchResponder!.touchBegan(lmiTouch.touch)
    }

    func moved() {
        self.touchResponder!.touchMoved(self.lmiTouch!.touch)
    }

    func ended() {
        print("tap ended")
        self.touchResponder!.touchEnded(self.lmiTouch!.touch)
        self.complete()
    }

    func cancelled() {
        print("tap cancelled")
        self.touchResponder!.touchCancelled(self.lmiTouch!.touch)
        self.complete()
    }

    func complete() {
        self.lmiTouch = nil
        self.touchResponder = nil
    }

}

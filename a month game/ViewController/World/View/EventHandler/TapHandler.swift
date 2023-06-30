//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class TapHandler {

    var touch: LMITouch?
    var touches: [LMITouch] {
        if let touch = self.touch {
            return [touch]
        } else {
            return []
        }
    }

    private let scene: WorldScene

    // MARK: - init
    init(scene: WorldScene) {
        self.scene = scene
    }

}

extension TapHandler: TouchHandler {

    func discriminate(touches: [LMITouch]) -> Bool { return true }

    func began(touches: [LMITouch]) {
        print("tap began")

        self.touch = touches[0]
    }

    func moved() {
        print("tap moved")
    }

    func ended() {
        print("tap ended")
        self.complete()
    }

    func cancelled() {
        print("tap cancelled")
        self.complete()
    }

    func complete() {
        self.touch = nil
    }

}

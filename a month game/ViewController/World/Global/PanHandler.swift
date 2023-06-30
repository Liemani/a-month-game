//
//  PanHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PanHandler {

    var scene: WorldScene

    var touch: LMITouch?
    var touches: [LMITouch] {
        if let touch = self.touch {
            return [touch]
        } else {
            return []
        }
    }

    init(scene: WorldScene) {
        self.scene = scene
    }

}

extension PanHandler: TouchHandler {

    func discriminate(touch: LMITouch) -> Bool {
        return touch.velocity(in: self.scene) >= Constant.panThreshold
    }

    func removeFromTracking(touch: LMITouch) {
    }

    func began(touches: [LMITouch]) {
        <#code#>
    }

    func moved() {
        <#code#>
    }

    func ended() {
        <#code#>
    }

    func cancelled() {
        <#code#>
    }

    func complete() {
        <#code#>
    }

}

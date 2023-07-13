//
//  ScenePinchLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class ScenePinchLogic: TouchLogic {

    private let scene: SKScene

    private var pDistance: Double
    private var scale: Double

    init(touches: [UITouch], scene: SKScene) {
        self.scene = scene

        self.pDistance = 0.0
        self.scale = 0.0

        super.init()

        self.touches = touches
    }

    var distance: Double {
        let diff = self.touches[0].location(in: self.scene)
            - self.touches[1].location(in: self.scene)

        return diff.magnitude
    }

    override func began() {
        self.pDistance = self.distance
        self.scale = Logics.default.world.scale
    }

    override func moved() {
        let distance = self.distance

        let scaleDelta = distance / self.pDistance
        var scale = self.scale * scaleDelta
        scale = max(Constant.minZoomScale, scale)
        scale = min(scale, Constant.maxZoomScale)

        Logics.default.world.scale = scale

        self.pDistance = distance
        self.scale = scale
    }

}

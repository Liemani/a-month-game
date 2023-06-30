//
//  PinchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PinchHandler {

    var touches: [LMITouch]

    private var scene: WorldScene
    private let world: SKNode

    private var pDistance: Double

    init(scene: WorldScene, world: SKNode) {
        self.touches = []

        self.scene = scene
        self.world = world

        self.pDistance = 0.0
    }

    var distance:Double {
        let difference = self.touches[0].location(in: self.scene)
            - self.touches[1].location(in: self.scene)

        return difference.magnitude
    }

}

extension PinchHandler: TouchHandler {

    func discriminate(touches: [LMITouch]) -> Bool {
        guard touches.count == 2
                && touches[0].possible.contains(.pinch)
                && touches[1].possible.contains(.pinch) else {
            return false
        }

        let currentTime = CACurrentMediaTime()

        if currentTime - touches[0].bTime > 1.0 {
            touches[0].possible.remove(.pinch)
            return false
        }

        if currentTime - touches[1].bTime > 1.0 {
            touches[1].possible.remove(.pinch)
            return false
        }

        var pTouch: LMITouch
        var cTouch: LMITouch

        var pTouchPLocation: CGPoint

        if touches[0].touch.timestamp == touches[1].touch.timestamp {
            pTouch = touches[0]
            cTouch = touches[1]

            pTouchPLocation = pTouch.previousLocation(in: self.scene)
        } else {
            if touches[0].touch.timestamp < touches[1].touch.timestamp {
                pTouch = touches[0]
                cTouch = touches[1]
            } else {
                pTouch = touches[1]
                cTouch = touches[0]
            }

            pTouchPLocation = pTouch.location(in: self.scene)
        }

        let pDifference = cTouch.previousLocation(in: self.scene) - pTouchPLocation
        let cDifference = cTouch.location(in: self.scene)
            - pTouch.location(in: self.scene)

        let delta = cDifference.magnitude - pDifference.magnitude

        let timeInterval = cTouch.touch.timestamp - cTouch.pTime

        let velocityDelta = delta / timeInterval

        return 100.0 < abs(velocityDelta)
    }

    func began(touches: [LMITouch]) {
        print("pinch began")

        self.touches = touches

        self.pDistance = self.distance
    }

    func moved() {
        print("pinch moved")

        let distance = self.distance

        let scaleDelta = distance / self.pDistance
        var scale = self.world.xScale * scaleDelta
        scale = max(Constant.minZoomScale, scale)
        scale = min(scale, Constant.maxZoomScale)

        self.world.xScale = scale
        self.world.yScale = scale

        self.pDistance = distance
    }

    func ended() {
        print("pinch ended")
        self.complete()
    }

    func cancelled() {
        print("pinch cancelled")
        self.complete()
    }

    func complete() {
        self.touches.removeAll()
    }

}

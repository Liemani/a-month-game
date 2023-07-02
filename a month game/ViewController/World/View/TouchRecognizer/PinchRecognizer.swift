//
//  PinchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PinchRecognizer {

    var lmiTouches: [LMITouch]

    private var scene: WorldScene
    private let ui: SKNode
    private let world: SKNode

    private var pDistance: Double

    init(scene: WorldScene, ui: SKNode, world: SKNode) {
        self.lmiTouches = []

        self.scene = scene
        self.ui = ui
        self.world = world

        self.pDistance = 0.0
    }

    var distance:Double {
        let difference = self.lmiTouches[0].location(in: self.scene)
            - self.lmiTouches[1].location(in: self.scene)

        return difference.magnitude
    }

}

extension PinchRecognizer: TouchRecognizer {

    func discriminate(lmiTouches: [LMITouch]) -> Bool {
        guard lmiTouches.count == 2
                && lmiTouches[0].possible.contains(.pinch)
                && lmiTouches[1].possible.contains(.pinch) else {
            return false
        }

        let currentTime = CACurrentMediaTime()

        guard currentTime - lmiTouches[0].bTime < 1.0
            && !lmiTouches[0].touchedNode.isDescendant(self.ui) else {
            lmiTouches[0].possible.remove(.pinch)

            return false
        }

        guard currentTime - lmiTouches[1].bTime < 1.0
            && !lmiTouches[1].touchedNode.isDescendant(self.ui) else {
            lmiTouches[1].possible.remove(.pinch)
            return false
        }

        var pTouch: LMITouch
        var cTouch: LMITouch

        var pTouchPLocation: CGPoint

        if lmiTouches[0].touch.timestamp == lmiTouches[1].touch.timestamp {
            pTouch = lmiTouches[0]
            cTouch = lmiTouches[1]

            pTouchPLocation = pTouch.previousLocation(in: self.scene)
        } else {
            if lmiTouches[0].touch.timestamp < lmiTouches[1].touch.timestamp {
                pTouch = lmiTouches[0]
                cTouch = lmiTouches[1]
            } else {
                pTouch = lmiTouches[1]
                cTouch = lmiTouches[0]
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

    func began(lmiTouches: [LMITouch]) {
        self.lmiTouches = lmiTouches

        self.pDistance = self.distance
    }

    func moved() {
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
        self.complete()
    }

    func cancelled() {
        self.complete()
    }

    func complete() {
        self.lmiTouches.removeAll()
    }

}

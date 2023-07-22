//
//  PinchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PinchRecognizer: TouchRecognizer {

    private var scene: SKScene
    private let ui: SKNode

    private var trackingRecognizerTouches: [RecognizerTouch]

    private var pDistance: Double

    init(scene: SKScene, ui: SKNode) {
        self.trackingRecognizerTouches = []

        self.scene = scene
        self.ui = ui

        self.pDistance = 0.0
    }

    var touches: [UITouch] { self.recognizerTouches.map { $0.touch } }

    var distance: Double {
        let difference = self.recognizerTouches[0].location(in: self.scene)
            - self.recognizerTouches[1].location(in: self.scene)

        return difference.magnitude
    }

    override func isPossible(recognizerTouch: RecognizerTouch) -> Bool {
        guard let responder = recognizerTouch.touchResponder else {
            return true
        }

        return responder.isRespondable(with: PinchRecognizer.self)
    }

    override func recognize(recognizerTouch: RecognizerTouch) -> Bool {
        if !self.trackingRecognizerTouches.contains(recognizerTouch) {
            self.trackingRecognizerTouches.append(recognizerTouch)
        }

        guard self.trackingRecognizerTouches.count == 2 else {
            return false
        }

        let cTime = CACurrentMediaTime()

        let touch1 = self.trackingRecognizerTouches[0]

        guard cTime - touch1.bTime < 1.0
                && !(touch1.touchResponder?.isDescendant(self.ui) ?? false) else {
            TouchManager.default.removePossible(from: touch1, recognizer: self)

            return false
        }

        let touch2 = self.trackingRecognizerTouches[1]

        guard cTime - touch2.bTime < 1.0
                && !(touch2.touchResponder?.isDescendant(self.ui) ?? false) else {
            TouchManager.default.removePossible(from: touch2, recognizer: self)

            return false
        }

        var pTouch: RecognizerTouch
        var cTouch: RecognizerTouch

        var pTouchPLocation: CGPoint

        if self.trackingRecognizerTouches[0].touch.timestamp == self.trackingRecognizerTouches[1].touch.timestamp {
            pTouch = self.trackingRecognizerTouches[0]
            cTouch = self.trackingRecognizerTouches[1]

            pTouchPLocation = pTouch.touch.previousLocation(in: self.scene)
        } else {
            if self.trackingRecognizerTouches[0].touch.timestamp < self.trackingRecognizerTouches[1].touch.timestamp {
                pTouch = self.trackingRecognizerTouches[0]
                cTouch = self.trackingRecognizerTouches[1]
            } else {
                pTouch = self.trackingRecognizerTouches[1]
                cTouch = self.trackingRecognizerTouches[0]
            }

            pTouchPLocation = pTouch.location(in: self.scene)
        }

        let pDifference = cTouch.touch.previousLocation(in: self.scene) - pTouchPLocation
        let cDifference = cTouch.location(in: self.scene)
            - pTouch.location(in: self.scene)

        let delta = cDifference.magnitude - pDifference.magnitude

        let timeInterval = cTouch.touch.timestamp - cTouch.pTime

        let velocityDelta = delta / timeInterval

        if 100.0 < abs(velocityDelta) {
            self.recognized(recognizerTouches: self.trackingRecognizerTouches)

            return true
        } else {
            return false
        }
    }

    private func recognized(recognizerTouches: [RecognizerTouch]) {
        for recognizerTouch in recognizerTouches {
            TouchServices.default.cancelled(recognizerTouch.touch)

            TouchManager.default.removePossible(from: recognizerTouch) { _ in
                true
            }
        }

        for recognizerTouch in recognizerTouches {
            self.recognizerTouches.append(recognizerTouch)
        }
    }

    override func free(recognizerTouch: RecognizerTouch) {
        self.trackingRecognizerTouches.removeAll { $0 === recognizerTouch }
        self.recognizerTouches.removeAll()
    }

    override func began() {
        let touchLogic = ScenePinchLogic(touches: self.touches, scene: self.scene)
        TouchServices.default.add(touchLogic)
        touchLogic.began()
    }

}

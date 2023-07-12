//
//  PanHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/30.
//

import Foundation
import SpriteKit

class PanRecognizer: TouchRecognizer {

    var recognizerTouch: RecognizerTouch? { self.recognizerTouches.first }

    private let scene: SKScene

    init(scene: SKScene) {
        self.scene = scene
    }

    override func recognize(recognizerTouch: RecognizerTouch) -> Bool {
//        let currentTime = CACurrentMediaTime()
//
//        guard currentTime - recognizerTouch.bTime < 1.0
//            && !recognizerTouch.touchedNode.isDescendant(self.ui) else {
//        guard !recognizerTouch.touchedNode.isDescendant(self.ui)
//                || recognizerTouch.touchResponder === self.infoWindow else {
//            recognizerTouch.possible.remove(.pan)
//
//            return false
//        }

//        return recognizerTouch.velocity(in: self.scene) >= Constant.panThreshold

        let positionDelta = recognizerTouch.touch.location(in: self.scene) - recognizerTouch.bPosition

        if positionDelta.magnitude >= Constant.tileWidth / 3.0 {
            self.recognized(recognizerTouch: recognizerTouch)

            return true
        } else {
            return false
        }
    }

    private func recognized(recognizerTouch: RecognizerTouch) {
        if let recognizerTouch = self.recognizerTouch {
            TouchLogics.default.cancelled(recognizerTouch.touch)
        }

        TouchManager.default.removePossible(from: recognizerTouch) {
            !($0 is PinchRecognizer)
        }

        self.recognizerTouches.append(recognizerTouch)
    }

    override func free(recognizerTouch: RecognizerTouch) {
        self.recognizerTouches.removeAll { $0 === recognizerTouch }
    }

    override func began() {
        let responder = self.recognizerTouch!.touchResponder!

        guard !Logics.default.scene.isDescendantOfUILayer(responder) else {
            return
        }

        var panLogic: TouchLogic

        switch responder {
        case is InfoWindow:
            panLogic = InfoWindowPanLogic(touch: self.recognizerTouch!.touch)
        default:
            panLogic = FieldPanLogic(touch: self.recognizerTouch!.touch,
                                              scene: self.scene)
        }

        TouchLogics.default.add(panLogic)
        panLogic.began()
    }

}

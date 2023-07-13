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

    override func isPossible(recognizerTouch: RecognizerTouch) -> Bool {
        guard let responder = recognizerTouch.touchResponder else {
            return true
        }

        return responder.isRespondable(with: PanRecognizer.self)
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
        if let pRecognizerTouch = self.recognizerTouch {
            TouchManager.default.recognizerCancelled(recognizer: self,
                                                     recognizerTouch: pRecognizerTouch)
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
        var panLogic: TouchLogic

        switch self.recognizerTouch!.touchResponder! {
        case is InfoWindow:
            panLogic = InfoWindowPanLogic(touch: self.recognizerTouch!.touch,
                                          scene: self.scene)
        default:
            panLogic = FieldPanLogic(touch: self.recognizerTouch!.touch,
                                     scene: self.scene)
        }

        TouchLogics.default.add(panLogic)
        panLogic.began()
    }

}

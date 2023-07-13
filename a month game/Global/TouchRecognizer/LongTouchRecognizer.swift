//
//  LongTouchRecognizer.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation
import SpriteKit

protocol TimeRecognizer {
}

class LongTouchRecognizer: TouchRecognizer, TimeRecognizer {

    var recognizerTouch: RecognizerTouch? { self.recognizerTouches.first }

    override func isPossible(recognizerTouch: RecognizerTouch) -> Bool {
        guard let responder = recognizerTouch.touchResponder else {
            return false
        }

        return responder.isRespondable(with: LongTouchRecognizer.self)
    }

    override func recognize(recognizerTouch: RecognizerTouch) -> Bool {
        if !recognizerTouch.touchResponder!.isBeing(touched: recognizerTouch.touch) {
            TouchManager.default.removePossible(from: recognizerTouch, recognizer: self)

            return false
        }

        let touchedDuration = CACurrentMediaTime() - recognizerTouch.bTime

        if touchedDuration >= Constant.longTouchThreshold {
            self.recognized(recognizerTouch: recognizerTouch)

            return true
        } else {
            return false
        }
    }

    private func recognized(recognizerTouch: RecognizerTouch) {
        TouchManager.default.removePossible(from: recognizerTouch) { _ in
            true
        }

        self.recognizerTouches.append(recognizerTouch)
    }

    override func began() {
        switch self.recognizerTouch!.touchResponder {
        case is Character:
            Logics.default.infoWindow.openCharacterInfo()
        default:
            break
        }

        self.recognizerTouches.removeAll()
    }

}

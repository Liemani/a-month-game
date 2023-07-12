//
//  CharacterMoveController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/17.
//

import Foundation
import SpriteKit

final class TapRecognizer: TouchRecognizer {

    var recognizerTouch: RecognizerTouch? { self.recognizerTouches.first }

    override func recognize(recognizerTouch: RecognizerTouch) -> Bool {
        self.recognized(recognizerTouch: recognizerTouch)

        return true
    }

    private func recognized(recognizerTouch: RecognizerTouch) {
        TouchManager.default.removePossible(from: recognizerTouch) {
            $0 is TapRecognizer
        }

        self.recognizerTouches.append(recognizerTouch)
    }

    override func free(recognizerTouch: RecognizerTouch) {
        self.recognizerTouches.removeAll { $0 === recognizerTouch }
    }

    override func began() {
        var tapLogic: TouchLogic

        switch self.recognizerTouch!.touchResponder {
        case let responder as Button:
            tapLogic = ButtonTapLogic(touch: self.recognizerTouch!.touch,
                                      button: responder)
        case let responder as Character:
            tapLogic = CharacterTapLogic(touch: self.recognizerTouch!.touch,
                                         character: responder)
        case let responder as GameObject:
            tapLogic = GameObjectTapLogic(touch: self.recognizerTouch!.touch,
                                                go: responder)
        case is MovingLayer:
            tapLogic = FieldTapLogic(touch: self.recognizerTouch!.touch)
        case let responder as InventoryCell:
            tapLogic = InventoryTapLogic(touch: self.recognizerTouch!.touch,
                                         cell: responder)
        case let responder as CraftCell:
            tapLogic = CraftTapLogic(touch: self.recognizerTouch!.touch,
                                     craftObject: responder.craftObject)
        default:
            return
        }

        TouchLogics.default.add(tapLogic)
        tapLogic.began()
    }

}

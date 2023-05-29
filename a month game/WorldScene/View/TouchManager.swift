//
//  TouchManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation
import SpriteKit

class TouchManager {

    var touches: [Touch?] = [Touch?](repeating: nil, count: 2)

    // MARK: - edit
    func first(from uiTouch: UITouch) -> Touch? {
        if let touch = touches[0], touch.uiTouch == uiTouch {
            return touch
        } else if let touch = touches[1], touch.uiTouch == uiTouch {
            return touch
        }
        return nil
    }

    func first(of touchType: Touch.Type) -> Touch? {
        if let touch = touches[0], type(of: touch) == touchType {
            return touch
        } else if let touch = touches[1], type(of: touch) == touchType {
            return touch
        }
        return nil
    }

    @discardableResult
    func add(_ touch: Touch) -> Bool {
        if touches[0] == nil {
            touches[0] = touch
        } else if touches[1] == nil {
            touches[1] = touch
        } else {
            return false
        }
        return true
    }

    func removeFirst(from uiTouch: UITouch) {
        if touches[0]?.uiTouch == uiTouch {
            touches[0] = nil
        } else if touches[1]?.uiTouch == uiTouch {
            touches[1] = nil
        }
    }

    func removeAll(of touchType: Touch.Type) {
        if let touch = touches[0], type(of: touch) == touchType {
            touches[0] = nil
        }
        if let touch = touches[1], type(of: touch) == touchType {
            touches[1] = nil
        }
    }

    // MARK: - delegate
    func cancel(of touchType: Touch.Type) {
        if let touch = touches[0], type(of: touch) == touchType {
            touch.sender.touchCancelled(touch.uiTouch)
        }
        if let touch = touches[1], type(of: touch) == touchType {
            touch.sender.touchCancelled(touch.uiTouch)
        }
    }

}

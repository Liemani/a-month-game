//
//  TouchManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation
import SpriteKit

class WorldSceneTouchContextManager {

    var contexts: [TouchContext?]!

    init() {
        self.contexts = [TouchContext?](repeating: nil, count: 2)
    }

    // MARK: - edit
    func contains(from uiTouch: UITouch) -> Bool {
        if contexts[0]?.uiTouch == uiTouch {
            return true
        } else if contexts[1]?.uiTouch == uiTouch {
            return true
        }
        return false
    }

    func first(from uiTouch: UITouch) -> TouchContext? {
        if let touch = contexts[0], touch.uiTouch == uiTouch {
            return touch
        } else if let touch = contexts[1], touch.uiTouch == uiTouch {
            return touch
        }
        return nil
    }

    func first(of touchType: TouchContext.Type) -> TouchContext? {
        if let touch = contexts[0], type(of: touch) == touchType {
            return touch
        } else if let touch = contexts[1], type(of: touch) == touchType {
            return touch
        }
        return nil
    }

    @discardableResult
    func add(_ touch: TouchContext) -> Bool {
        if contexts[0] == nil {
            contexts[0] = touch
            return true
        } else if contexts[1] == nil {
            contexts[1] = touch
            return true
        }
        return false
    }

    func removeFirst(from uiTouch: UITouch) {
        if contexts[0]?.uiTouch == uiTouch {
            contexts[0] = nil
        } else if contexts[1]?.uiTouch == uiTouch {
            contexts[1] = nil
        }
    }

    // MARK: - delegate
    func cancelAll(of touchType: TouchContext.Type) {
        if let touch = contexts[0], type(of: touch) == touchType {
            touch.sender.touchCancelled(touch.uiTouch)
        }
        if let touch = contexts[1], type(of: touch) == touchType {
            touch.sender.touchCancelled(touch.uiTouch)
        }
    }

    func cancelAll() {
        if let touch = contexts[0] {
            touch.sender.touchCancelled(touch.uiTouch)
        } else if let touch = contexts[1] {
            touch.sender.touchCancelled(touch.uiTouch)
        }
    }

}

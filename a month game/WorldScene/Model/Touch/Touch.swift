//
//  Touch.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation
import SpriteKit

class Touch {

    let uiTouch: UITouch
    let sender: UIResponder

    init(touch: UITouch, sender: UIResponder) {
        self.uiTouch = touch
        self.sender = sender
    }

}

extension Touch: Equatable {

    static func == (lhs: Touch, rhs: Touch) -> Bool {
        return lhs.uiTouch == rhs.uiTouch
    }

    public static func != (lhs: Touch, rhs: Touch) -> Bool {
        return !(lhs == rhs)
    }

}

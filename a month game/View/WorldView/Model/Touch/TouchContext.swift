//
//  Touch.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation
import SpriteKit

class TouchContext {

    let uiTouch: UITouch
    let sender: LMITouchResponder

    init(touch: UITouch, sender: LMITouchResponder) {
        self.uiTouch = touch
        self.sender = sender
    }

}

extension TouchContext: Equatable {

    static func == (lhs: TouchContext, rhs: TouchContext) -> Bool {
        return lhs.uiTouch == rhs.uiTouch
    }

    public static func != (lhs: TouchContext, rhs: TouchContext) -> Bool {
        return !(lhs == rhs)
    }

}

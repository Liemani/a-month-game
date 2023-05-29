//
//  Touch.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation
import SpriteKit

class TouchModel {

    let uiTouch: UITouch
    let sender: UIResponder

    init(touch: UITouch, sender: UIResponder) {
        self.uiTouch = touch
        self.sender = sender
    }

}

extension TouchModel: Equatable {

    static func == (lhs: TouchModel, rhs: TouchModel) -> Bool {
        return lhs.uiTouch == rhs.uiTouch
    }

    public static func != (lhs: TouchModel, rhs: TouchModel) -> Bool {
        return !(lhs == rhs)
    }

}

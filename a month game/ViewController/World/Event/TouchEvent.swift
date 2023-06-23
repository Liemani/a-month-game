//
//  TouchEventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

enum TouchEventType {

    case characterTouchBegan
    case gameObjectTouchBegan

}

class TouchEvent {

    let type: TouchEventType
    let touch: UITouch

    let sender: Any

    init(type: TouchEventType, touch: UITouch, sender: Any) {
        self.type = type
        self.touch = touch
        self.sender = sender
    }

}

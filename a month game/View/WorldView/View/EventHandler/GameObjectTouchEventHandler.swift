//
//  GameObjectTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class GameObjectTouchEventHandler {

    let sender: GameObject
    let touch: UITouch

    init(sender: GameObject, touch: UITouch) {
        self.sender = sender
        self.touch = touch
    }

}

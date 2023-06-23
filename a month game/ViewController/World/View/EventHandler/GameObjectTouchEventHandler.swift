//
//  GameObjectTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class GameObjectTouchEventHandler {

    let touch: UITouch

    private let go: GameObject

    init(touch: UITouch, go: GameObject) {
        self.touch = touch
        self.go = go
    }

}

extension GameObjectTouchEventHandler: TouchEventHandler {
    
    func touchBegan() {
        print("game object touch began")
    }

    func touchMoved() {
        print("game object touch moved")
    }

    func touchEnded() {
        print("game object touch ended")
    }

    func touchCancelled() {
        print("game object touch cancelled")
    }

}

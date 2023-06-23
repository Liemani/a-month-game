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
        self.go.activate()
    }

    func touchMoved() {
        if self.go.isAtLocation(of: touch) {
            return
        }

        EventManager.default.touchEventHandlerManager.remove(from: self.touch)
        let event = TouchEvent(type: .gameObjectMoveTouchBegan,
                               touch: touch,
                               sender: self.go)
        EventManager.default.touchBeganEventQueue.enqueue(event)
        self.touchCancelled()
    }

    func touchEnded() {
        self.go.deactivate()
    }

    func touchCancelled() {
        self.go.deactivate()
    }

}

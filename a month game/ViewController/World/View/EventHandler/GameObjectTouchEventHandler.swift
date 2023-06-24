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

        print("if enough long, activate long touch and cancel self")

        self.touchCancelled()

        TouchEventHandlerManager.default.remove(from: self.touch)
        let event = TouchBeganEvent(type: .gameObjectMove,
                               touch: touch,
                               sender: self.go)
        TouchBeganEventManager.default.enqueue(event)
    }

    func touchEnded() {
        print("interact world event")

        self.go.deactivate()
    }

    func touchCancelled() {
        self.go.deactivate()
    }

}

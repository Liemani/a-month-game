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
        print("add long touch timer")
    }

    func touchMoved() {
        if self.go.isBeing(touched: touch) {
            return
        }

        self.touchCancelled()

        let event = Event(type: .gameObjectMoveTouchBegan,
                          udata: touch,
                          sender: self.go)
        EventManager.default.enqueue(event)
    }

    func touchEnded() {
        let event = Event(type: .gameObjectInteract,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event)

        self.complete()
    }

    func touchCancelled() {
        self.complete()
    }

    func complete() {
        self.go.deactivate()
        TouchEventHandlerManager.default.remove(from: self.touch)
    }

}

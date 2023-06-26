//
//  GameObjectMoveTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/23.
//

import Foundation
import SpriteKit

class GameObjectMoveTouchEventHandler: TouchEventHandler {

    var touch: UITouch

    private let go: GameObject

    init(touch: UITouch, go: GameObject) {
        self.touch = touch
        self.go = go
    }

    func touchBegan() {
        if self.go.chunkCoord != nil && !self.go.type.isPickable {
            self.complete()
            return
        }

        self.go.activate()

        let event = Event(type: .gameObjectMoveToUI,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event)

        let event2 = Event(type: .accessibleGOTrackerRemove,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event2)

        self.touchMoved()
    }

    func touchMoved() {
        self.go.setPositionToLocation(of: touch)
    }

    func touchEnded() {
        let event = Event(type: .gameObjectMoveTouchEnded,
                               udata: self.touch,
                               sender: self.go)
        EventManager.default.enqueue(event)

        self.complete()
    }

    func touchCancelled() {
        let event = Event(type: .gameObjectMoveToBelong,
                          udata: nil,
                          sender: self.go)
        EventManager.default.enqueue(event)

        self.complete()
    }

    func complete() {
        self.go.deactivate()
        TouchEventHandlerManager.default.remove(from: self.touch)
    }

}

//
//  GameObjectMoveTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/23.
//

//import Foundation
//import SpriteKit
//
//class GameObjectMoveTouchEventHandler: GestureEventHandler {
//
//    var recognizer: UIGestureRecognizer
//
//    private let go: GameObject
//
//    init(touch: UITouch, go: GameObject) {
//        self.recognizer = touch
//        self.go = go
//    }
//
//    func began() {
//        if self.go.chunkCoord != nil && !self.go.type.isPickable {
//            self.complete()
//            return
//        }
//
//        self.go.activate()
//
//        let event = Event(type: .gameObjectMoveToUI,
//                          udata: nil,
//                          sender: self.go)
//        EventManager.default.enqueue(event)
//
//        let event2 = Event(type: .accessibleGOTrackerRemove,
//                          udata: nil,
//                          sender: self.go)
//        EventManager.default.enqueue(event2)
//
//        self.moved()
//    }
//
//    func moved() {
//        self.go.setPositionToLocation(of: recognizer)
//    }
//
//    func ended() {
//        let event = Event(type: .gameObjectMoveTouchEnded,
//                               udata: self.recognizer,
//                               sender: self.go)
//        EventManager.default.enqueue(event)
//
//        self.complete()
//    }
//
//    func cancelled() {
//        let event = Event(type: .gameObjectMoveToBelong,
//                          udata: nil,
//                          sender: self.go)
//        EventManager.default.enqueue(event)
//
//        self.complete()
//    }
//
//    func complete() {
//        self.go.deactivate()
//        GestureEventHandlerManager.default.remove(from: self.recognizer)
//    }
//
//}

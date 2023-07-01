//
//  GameObjectTouchEventHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

//import Foundation
//import SpriteKit
//
//class GameObjectTouchEventHandler {
//
//    let recognizer: UIGestureRecognizer
//
//    private let go: GameObject
//
//    init(touch: UITouch, go: GameObject) {
//        self.recognizer = touch
//        self.go = go
//    }
//
//}
//
//extension GameObjectTouchEventHandler: GestureEventHandler {
//
//    func began() {
//        self.go.activate()
//        print("add long touch timer")
//    }
//
//    func moved() {
//        if self.go.isBeing(touched: recognizer) {
//            return
//        }
//
//        self.cancelled()
//
//        let event = Event(type: .gameObjectMoveTouchBegan,
//                          udata: recognizer,
//                          sender: self.go)
//        EventManager.default.enqueue(event)
//    }
//
//    func ended() {
//        let event = Event(type: .gameObjectInteract,
//                          udata: nil,
//                          sender: self.go)
//        EventManager.default.enqueue(event)
//
//        self.complete()
//    }
//
//    func cancelled() {
//        self.complete()
//    }
//
//    func complete() {
//        self.go.deactivate()
//        GestureEventHandlerManager.default.remove(from: self.recognizer)
//    }
//
//}

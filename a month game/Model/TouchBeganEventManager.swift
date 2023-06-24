//
//  EventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

enum TouchBeganEventType {

    case character
    case gameObject
    case gameObjectMove

}

class TouchBeganEvent {

    let type: TouchBeganEventType
    let touch: UITouch

    let sender: Any

    init(type: TouchBeganEventType, touch: UITouch, sender: Any) {
        self.type = type
        self.touch = touch
        self.sender = sender
    }

}

class TouchBeganEventManager {

    private static var _default: TouchBeganEventManager?
    static var `default`: TouchBeganEventManager { self._default! }

    static func set() { self._default = TouchBeganEventManager() }
    static func free() { self._default = nil }

    private let queue: Queue<TouchBeganEvent>

    init() {
        self.queue = Queue(size: Constant.touchBeganEventQueueSize)
    }

    func enqueue(_ element: Element) {
        self.queue.enqueue(element)
    }

    func dequeue() -> Element? {
        return self.queue.dequeue()
    }

}

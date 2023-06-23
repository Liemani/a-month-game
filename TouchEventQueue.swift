//
//  TouchEventQueue.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

class QueueObject<Element> {

    var queue: Queue<Element>

    init(size: Int) {
        self.queue = Queue(size: size)
    }

    func enqueue(_ element: Element) {
        self.queue.enqueue(element)
    }

    func dequeue() -> Element? {
        return self.queue.dequeue()
    }

}

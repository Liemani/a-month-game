//
//  Queue.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation

struct Queue<Element> {

    private var front: Int
    private var rear: Int
    private var elements: [Element?]
    private var size: Int { self.elements.count }

    init(size: Int) {
        self.front = 0
        self.rear = 0
        self.elements = [Element?](repeating: nil, count: size)
    }

    mutating func enqueue(_ element: Element) {
        let next = self.next(self.rear)
        guard next != front else {
            return
        }

        self.elements[self.rear] = element
        self.rear = next
    }

    mutating func dequeue() -> Element? {
        guard front != rear else {
            return nil
        }

        let element = self.elements[self.front]
        self.front = self.next(self.front)
        return element
    }

    private func next(_ index: Int) -> Int {
        return (index + 1) % self.size
    }

}

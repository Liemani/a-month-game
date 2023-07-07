//
//  Event.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/29.
//

import Foundation
import SpriteKit

protocol EventType {

    var manager: EventManager { get }

}

class Event {

    let type: EventType
    let udata: Any?

    let sender: Any

    init(type: EventType, udata: Any?, sender: Any) {
        self.type = type
        self.udata = udata
        self.sender = sender
    }

    var manager: EventManager {
        return self.type.manager
    }

}

protocol EventManager {

    func enqueue(_ event: Event)
    func dequeue() -> Event?

}

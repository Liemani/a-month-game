//
//  LMIEventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/19.
//

import Foundation

enum EventHandlerType: Int, CaseIterable {

    case controller
    case scene

}

class EventManager {

    var events: [[Event]]

    init() {
        let eventsCount = EventHandlerType.allCases.count
        self.events = [[Event]](repeating: [], count: eventsCount)
    }

    func send(event: Event, to handler: EventHandlerType) {
        self.events[handler].append(event)
    }

}

protocol Sender { }

class Event {

    let sender: Sender

    init(sender: Sender) {
        self.sender = sender
    }

}

class GameObjectInteractEvent: Event {

    let lhGONode: GameObjectNode
    let rhGONode: GameObjectNode

    init(lhGONode: GameObjectNode, rhGONode: GameObjectNode, sender: Sender) {
        self.lhGONode = lhGONode
        self.rhGONode = rhGONode
        super.init(sender: sender)
    }

}

class GameObjectMoveEvent: Event { }

//
//  SceneEvent.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

enum WorldEventType: Int, CaseIterable, EventType {

    var manager: EventManager { WorldEventManager.default }
    var handler: (WorldScene, Event) -> Void { WorldEventType.eventHandlers[self] }

    case menuButton
    case menuExitButton

    static let eventHandlers: [(WorldScene, Event) -> Void] = [
        { scene, event in // menuButton
            scene.munuWindow.reveal()
        },

        { scene, event in // menuExitButton
            NotificationCenter.default.post(name: .requestPresentPortalSceneViewController, object: nil)
        },
    ]

}

class TimeEvent {

    let timeout: TimeInterval

    init(timeout: TimeInterval) {
        self.timeout = timeout
    }

    func shouldHandle(_ currentTime: TimeInterval) -> Bool {
        return currentTime >= timeout
    }

    func handle() { }

}

class TimeEvents {

    var events: [TimeEvent]

    init() {
        self.events = []
    }

    func update(_ currentTime: TimeInterval) {
        for event in events {
            if event.shouldHandle(currentTime) {
                self.events.removeAll { $0 === event }
                event.handle()
            }
        }
    }

    func remove(of lmiTouch: LMITouch) {
        self.events.removeAll {
            if let event = $0 as? LongTouchTimeEvent {
                return event.lmiTouch === lmiTouch
            }

            return false
        }
    }

}

class LongTouchTimeEvent: TimeEvent {

    let lmiTouch: LMITouch

    init(lmiTouch: LMITouch, timeout: TimeInterval) {
        self.lmiTouch = lmiTouch

        super.init(timeout: timeout)
    }

    override func handle() {
        TouchRecognizerManager.default.longTouch.began(lmiTouches: [self.lmiTouch])
    }

}

class WorldEventManager: EventManager {

    private static var _default: WorldEventManager?
    static var `default`: WorldEventManager { self._default! }

    static func set() { self._default = WorldEventManager() }
    static func free() { self._default = nil }

    private var queue: Queue<Event>
    private let timeEvents: TimeEvents

    init() {
        self.queue = Queue(size: Constant.worldEventQueueSize)
        self.timeEvents = TimeEvents()
    }

    func enqueue(_ event: Event) {
        self.queue.enqueue(event)
    }

    func dequeue() -> Event? {
        return self.queue.dequeue()
    }

    func updateTimeEvent(_ currentTime: TimeInterval) {
        self.timeEvents.update(currentTime)
    }

    func addLongTouchTimeEvent(lmiTouch: LMITouch, timeout: TimeInterval) {
        let timeEvent = LongTouchTimeEvent(lmiTouch: lmiTouch, timeout: timeout)
        self.timeEvents.events.append(timeEvent)
    }

    func removeLongTouchTimeEvent(of lmiTouch: LMITouch) {
        self.timeEvents.remove(of: lmiTouch)
    }

}

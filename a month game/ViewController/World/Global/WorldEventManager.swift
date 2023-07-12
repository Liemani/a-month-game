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
            scene.menuWindow.reveal()
        },

        { scene, event in // menuExitButton
            NotificationCenter.default.post(name: .requestPresentPortalSceneViewController, object: nil)
        },
    ]

}

class WorldEventManager: EventManager {

    private static var _default: WorldEventManager?
    static var `default`: WorldEventManager { self._default! }

    static func set() { self._default = WorldEventManager() }
    static func free() { self._default = nil }

    private var queue: Queue<Event>

    init() {
        self.queue = Queue(size: Constant.worldEventQueueSize)
    }

    func enqueue(_ event: Event) {
        self.queue.enqueue(event)
    }

    func dequeue() -> Event? {
        return self.queue.dequeue()
    }

}

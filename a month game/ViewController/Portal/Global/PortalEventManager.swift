//
//  PortalEventManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/29.
//

import Foundation
import SpriteKit

enum PortalEventType: Int, CaseIterable, EventType {

    var manager: EventManager { PortalEventManager.default }
    var handler: (PortalScene, Event) -> Void { PortalEventType.eventHandlers[self] }

    case enterButton
    case resetButton
    case resetYesButton
    case resetNoButton

    static let eventHandlers: [(PortalScene, Event) -> Void] = [
        { scene, event in // enterButton
            NotificationCenter.default.post(name: .requestPresentWorldSceneViewController, object: nil)
        },

        { scene, event in // resetButton
            scene.resetWindow.reveal()
        },

        { scene, event in // resetYesButton
            WorldDirectoryUtility.default.remove(worldName: Constant.Name.defaultWorld)
            scene.resetWindow.hide()
        },

        { scene, event in // resetNoButton
            scene.resetWindow.hide()
        },
    ]

}

class PortalEventManager: EventManager {

    private static var _default: PortalEventManager?
    static var `default`: PortalEventManager { self._default! }

    static func set() { self._default = PortalEventManager() }
    static func free() { self._default = nil }

    private var queue: Queue<Event>

    init() {
        self.queue = Queue(size: Constant.portalEventQueueSize)
    }

    func enqueue(_ event: Event) {
        self.queue.enqueue(event)
    }

    func dequeue() -> Event? {
        return self.queue.dequeue()
    }

}

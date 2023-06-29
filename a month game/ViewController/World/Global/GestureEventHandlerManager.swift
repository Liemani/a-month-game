//
//  GestureEventHandlerManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation
import SpriteKit

protocol GestureEventHandler {

    var recognizer: UIGestureRecognizer { get }

    func began()
    func moved()
    func ended()
    func cancelled()
    func complete()

}

class GestureEventHandlerManager {

    private static var _default: GestureEventHandlerManager?
    static var `default`: GestureEventHandlerManager { self._default! }

    static func set() { self._default = GestureEventHandlerManager() }
    static func free() { self._default = nil }

    private var handlers: [GestureEventHandler?]

    init() {
        self.handlers = [GestureEventHandler?](repeating: nil, count: 2)
    }

    // MARK: - edit
    func contains(from recognizer: UIGestureRecognizer) -> Bool {
        if self.handlers[0]?.recognizer == recognizer {
            return true
        } else if self.handlers[1]?.recognizer == recognizer {
            return true
        }
        return false
    }

    func handler(from recognizer: UIGestureRecognizer) -> GestureEventHandler? {
        if let handler = self.handlers[0], handler.recognizer == recognizer {
            return handler
        } else if let handler = self.handlers[1], handler.recognizer == recognizer {
            return handler
        }
        return nil
    }

    func handler(of handlerType: GestureEventHandler.Type) -> GestureEventHandler? {
        if let handler = self.handlers[0], type(of: handler) == handlerType {
            return handler
        } else if let handler = self.handlers[1], type(of: handler) == handlerType {
            return handler
        }
        return nil
    }

    func add(_ handler: GestureEventHandler) -> Bool {
        if self.handlers[0] == nil {
            self.handlers[0] = handler
            return true
        } else if self.handlers[1] == nil {
            self.handlers[1] = handler
            return true
        }
        return false
    }

    func remove(from recognizer: UIGestureRecognizer) {
        if self.handlers[0]?.recognizer == recognizer {
            self.handlers[0] = nil
        } else if self.handlers[1]?.recognizer == recognizer {
            self.handlers[1] = nil
        }
    }

    func cancelAll(of handlerType: GestureEventHandler.Type) {
        if let handler = self.handlers[0],
            type(of: handler) == handlerType {
                handler.cancelled()
                    self.handlers[0] = nil
            }
        if let handler = self.handlers[1],
            type(of: handler) == handlerType {
                handler.cancelled()
                    self.handlers[1] = nil
            }
    }

    func cancelAll() {
        if let handler = self.handlers[0] {
            handler.cancelled()
            self.handlers[0] = nil
        }
        if let handler = self.handlers[1] {
            handler.cancelled()
            self.handlers[1] = nil
        }
    }

}

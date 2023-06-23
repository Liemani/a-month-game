//
//  TouchManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation
import SpriteKit

class TouchEventHandlerManager {

    private var handlers: [TouchEventHandler?]

    init() {
        self.handlers = [TouchEventHandler?](repeating: nil, count: 2)
    }

    // MARK: - edit
    func contains(from touch: UITouch) -> Bool {
        if self.handlers[0]?.touch == touch {
            return true
        } else if self.handlers[1]?.touch == touch {
            return true
        }
        return false
    }

    func handler(from touch: UITouch) -> TouchEventHandler? {
        if let handler = self.handlers[0], handler.touch == touch {
            return handler
        } else if let handler = self.handlers[1], handler.touch == touch {
            return handler
        }
        return nil
    }

    func handler(of handlerType: TouchEventHandler.Type) -> TouchEventHandler? {
        if let handler = self.handlers[0], type(of: handler) == handlerType {
            return handler
        } else if let handler = self.handlers[1], type(of: handler) == handlerType {
            return handler
        }
        return nil
    }

    func add(_ handler: TouchEventHandler) -> Bool {
        if self.handlers[0] == nil {
            self.handlers[0] = handler
            return true
        } else if self.handlers[1] == nil {
            self.handlers[1] = handler
            return true
        }
        return false
    }

    func remove(from touch: UITouch) {
        if self.handlers[0]?.touch == touch {
            self.handlers[0] = nil
        } else if self.handlers[1]?.touch == touch {
            self.handlers[1] = nil
        }
    }

    func cancelAll(of handlerType: TouchEventHandler.Type) {
        if let handler = self.handlers[0],
           type(of: handler) == handlerType {
            handler.touchCancelled()
            self.handlers[0] = nil
        }
        if let handler = self.handlers[1],
           type(of: handler) == handlerType {
            handler.touchCancelled()
            self.handlers[1] = nil
        }
    }

    func cancelAll() {
        if let handler = self.handlers[0] {
            handler.touchCancelled()
            self.handlers[0] = nil
        }
        if let handler = self.handlers[1] {
            handler.touchCancelled()
            self.handlers[1] = nil
        }
    }

}

//
//  UITouchManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation
import SpriteKit

struct TouchPossible: OptionSet {

    var rawValue: Int

    static let tap = TouchPossible(rawValue: 0x1 << 0)
    static let pan = TouchPossible(rawValue: 0x1 << 1)
    static let pinch = TouchPossible(rawValue: 0x1 << 2)

}

class LMITouch {

    let touch: UITouch
    let bTime: TimeInterval
    var pTime: TimeInterval
    var handler: TouchHandler?
    var possible: TouchPossible

    init(_ touch: UITouch) {
        self.touch = touch
        self.bTime = touch.timestamp
        self.pTime = touch.timestamp
        let rawValue = TouchPossible.tap.rawValue
            | TouchPossible.pan.rawValue
            | TouchPossible.pinch.rawValue
        self.possible = TouchPossible(rawValue: rawValue)
    }

    func location(in node: SKNode) -> CGPoint {
        self.touch.location(in: node)
    }

    func previousLocation(in node: SKNode) -> CGPoint {
        return self.touch.previousLocation(in: node)
    }

    func update() {
        self.pTime = self.touch.timestamp
    }

    func cancelHandler() {
        if let handler = self.handler {
            handler.cancelled()
        }
    }

    func velocity(in node: SKNode) -> CGFloat {
        let cPoint = touch.previousLocation(in: node)
        let pPoint = touch.location(in: node)
        let deltaPoint = cPoint - pPoint

        let cTime = self.touch.timestamp
        let deltaTime = cTime - self.pTime

        return deltaPoint.magnitude / deltaTime
    }

}

extension LMITouch: Equatable {

    static func == (lhs: LMITouch, rhs: LMITouch) -> Bool {
        return lhs.touch == rhs.touch
    }

    static func != (lhs: LMITouch, rhs: LMITouch) -> Bool {
        return !(lhs == rhs)
    }

}

extension LMITouch: Hashable {

    func hash(into hasher: inout Hasher) {
        self.touch.hash(into: &hasher)
    }

}

protocol TouchHandler {

    var touches: [LMITouch] { get }

    func discriminate(touches: [LMITouch]) -> Bool

    func began(touches: [LMITouch])
    func moved()
    func ended()
    func cancelled()
    func complete()

}

enum TouchHandlerIndex: Int, CaseIterable {

    case tapHandler1
    case tapHandler2
    case panHandler
    case pinchHandler

    static let tapIndices: [TouchHandlerIndex] = [
        .tapHandler1,
        .tapHandler2,
    ]

}

class TouchContainer {

    var touches: [LMITouch]

    init() {
        self.touches = []
    }

    var count: Int { self.touches.count }

    func contains(touch: UITouch) -> Bool {
        var lmiTouch = self.touches[0]
        if  lmiTouch.touch == touch {
            return true
        }

        lmiTouch = self.touches[1]
        if lmiTouch.touch == touch {
            return true
        }

        return false
    }

    func element(touch: UITouch) -> LMITouch? {
        for lmiTouch in self.touches {
            if lmiTouch.touch == touch {
                return lmiTouch
            }
        }

        return nil
    }

    func add(touch: LMITouch) {
        guard self.touches.count < 2 else {
            return
        }

        self.touches.append(touch)
    }

    func remove(touch: LMITouch) {
        self.touches.removeAll { $0 == touch }
    }

    func cancelAll() {
        for touch in self.touches {
            touch.handler!.cancelled()
            self.touches.removeAll()
        }
    }

}

class TouchManager {

    private static var _default: TouchManager?
    static var `default`: TouchManager { self._default! }

    static func set(scene: WorldScene, character: Character) {
        self._default = TouchManager(scene: scene, character: character)
    }
    static func free() { self._default = nil }

    let touchContainer: TouchContainer
    let handlers: [TouchHandler]

    var panHandler: PanHandler {
        return self.handlers[TouchHandlerIndex.panHandler] as! PanHandler
    }

    var pinchHandler: PinchHandler {
        return self.handlers[TouchHandlerIndex.pinchHandler] as! PinchHandler
    }

    init(scene: WorldScene, character: Character) {
        self.touchContainer = TouchContainer()
        self.handlers = [
            TapHandler(scene: scene),
            TapHandler(scene: scene),
            PanHandler(scene: scene, character: character),
            PinchHandler(scene: scene, world: scene.worldLayer),
        ]
    }

    func handler(containing touch: UITouch) -> TouchHandler? {
        for handler in self.handlers {
            if handler.touches.contains(where: { $0.touch == touch }) {
                return handler
            }
        }
        return nil
    }

    func cancelAllTouches() {
        self.touchContainer.cancelAll()
    }

}

extension TouchManager: TouchResponder {

    // MARK: - touch began
    func touchBegan(_ touch: UITouch) {
        guard self.touchContainer.count < 2 else {
            return
        }

        let lmiTouch = LMITouch(touch)

        self.touchBeganHandle(lmiTouch)

        lmiTouch.update()
    }

    private func touchBeganHandle(_ lmiTouch: LMITouch) {
        self.touchContainer.add(touch: lmiTouch)

        for index in TouchHandlerIndex.tapIndices {
            let tapHandler = self.handlers[index]

            guard tapHandler.touches.first == nil else {
                continue
            }

            lmiTouch.handler = tapHandler

            tapHandler.began(touches: [lmiTouch])

            return
        }
    }

    // MARK: - touch moved
    func touchMoved(_ touch: UITouch) {
        guard let lmiTouch = self.touchContainer.element(touch: touch) else {
            return
        }

        self.touchMovedHandle(lmiTouch)

        lmiTouch.update()
    }

    private func touchMovedHandle(_ lmiTouch: LMITouch) {
        if let handler = lmiTouch.handler {
            switch handler {
            case is PinchHandler:
                handler.moved()
                return
            case is PanHandler:
                handler.moved()
                return
            default:
                break
            }
        }

        if self.touchContainer.count == 2
            && self.pinchHandler.discriminate(touches: self.touchContainer.touches) {
            let touches = self.touchContainer.touches

            for touch in touches {
                touch.cancelHandler()
                touch.handler = self.pinchHandler
            }

            self.pinchHandler.began(touches: touches)

            return
        }

        if self.panHandler.discriminate(touches: [lmiTouch]) {
            lmiTouch.cancelHandler()
            lmiTouch.handler = self.panHandler

            self.panHandler.began(touches: [lmiTouch])

            return
        }

        lmiTouch.handler!.moved()
    }

    // MARK: - touch ended
    func touchEnded(_ touch: UITouch) {
        guard let lmiTouch = self.touchContainer.element(touch: touch) else {
            return
        }

        self.touchEndedHandle(lmiTouch)
    }

    private func touchEndedHandle(_ lmiTouch: LMITouch) {
        let handler = lmiTouch.handler!
        let touches = handler.touches

        handler.ended()

        for touch in touches {
            self.touchContainer.remove(touch: touch)
        }
    }

    // MARK: - touch cancelled
    func touchCancelled(_ touch: UITouch) {
        guard let lmiTouch = self.touchContainer.element(touch: touch) else {
            return
        }

        self.touchCancelledHandle(lmiTouch)
    }

    private func touchCancelledHandle(_ lmiTouch: LMITouch) {
        let handler = lmiTouch.handler!
        let touches = handler.touches

        handler.cancelled()

        for touch in touches {
            self.touchContainer.remove(touch: touch)
        }

    }

}

//
//  UITouchManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation
import SpriteKit

enum TouchHandlerType: Int, CaseIterable {

    case none
    case tap
    case pan
    case pinch

}

class LMITouch {

    let touch: UITouch
    var pTime: TimeInterval
    var possible: Set<TouchHandlerType>

    init(_ touch: UITouch) {
        self.touch = touch
        self.pTime = touch.timestamp
    }

    func update() {
        self.pTime = self.touch.timestamp
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

    func discriminate(touch: LMITouch) -> Bool
    func removeFromTracking(touch: LMITouch)

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

class TouchManager {

    private static var _default: TouchManager?
    static var `default`: TouchManager { self._default! }

    static func set(scene: WorldScene, character: Character) {
        self._default = TouchManager(scene: scene, character: character)
    }
    static func free() { self._default = nil }

    let handlers: [TouchHandler]

    var panHandler: PanHandler {
        return self.handlers[TouchHandlerIndex.panHandler] as! PanHandler
    }

    var pinchHandler: PinchHandler {
        return self.handlers[TouchHandlerIndex.pinchHandler] as! PinchHandler
    }

    init(scene: WorldScene, character: Character) {
        self.handlers = [
            TapHandler(scene: scene, character: character),
            TapHandler(scene: scene, character: character),
            PanHandler(scene: scene),
            PinchHandler(),
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

}

extension TouchManager: TouchResponder {

    func touchBegan(_ touch: UITouch) {
        let touch = LMITouch(touch)
        for index in TouchHandlerIndex.tapIndices {
            let tapHandler = self.handlers[index]
            guard tapHandler.touches.first != nil else {
                continue
            }

            tapHandler.began(touches: [touch])

            return
        }
    }

    func touchMoved(_ touch: UITouch) {
        guard let handler = self.handler(containing: touch) else {
            return
        }

        if handler is PinchHandler
            || handler is PanHandler {
            handler.moved()

            return
        }

        let pinchHandler = self.pinchHandler
        if pinchHandler.discriminate(touch: handler.touches[0]) {
            for touch in pinchHandler.touches {
                if let handler = self.handler(containing: touch.touch) {
                    if handler is
                    handler.cancelled()
                }
            }
            let touch1 =
            pinchHandler.began(touches: <#T##[UITouch]#>)

            return
        }

        let panHandler = self.panHandler
        if panHandler.discriminate() {

            return
        }
    }

    func touchEnded(_ touch: UITouch) {
        guard let handler = self.handler(containing: touch) else {
            return
        }

        if handler is TapHandler
            || handler is PanHandler {
            let lmiTouch = handler.touches[0]
            self.pinchHandler.removeFromTracking(touch: lmiTouch)
            handler.ended()

            return
        }

        handler.ended()
    }

    func touchCancelled(_ touch: UITouch) {
        guard let handler = self.handler(containing: touch) else {
            return
        }

        if handler is TapHandler
            || handler is PanHandler {
            let lmiTouch = handler.touches[0]
            self.pinchHandler.removeFromTracking(touch: lmiTouch)
            handler.cancelled()

            return
        }

        handler.cancelled()
    }

}

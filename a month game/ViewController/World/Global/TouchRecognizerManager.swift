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
    let bPosition: CGPoint
    let bTime: TimeInterval
    var pTime: TimeInterval
    var recognizer: TouchRecognizer?
    var possible: TouchPossible
    var touchedNode: SKNode!
    var touchResponder: TouchResponder?

    init(_ touch: UITouch, scene: WorldScene) {
        self.touch = touch
        self.bPosition = touch.location(in: scene)
        self.bTime = touch.timestamp
        self.pTime = touch.timestamp
        let rawValue = TouchPossible.tap.rawValue
            | TouchPossible.pan.rawValue
            | TouchPossible.pinch.rawValue
        self.possible = TouchPossible(rawValue: rawValue)
        self.touchResponder = nil
        self.setTouchResponder(scene: scene)
    }

    private func setTouchResponder(scene: WorldScene) {
        let touchPoint = self.touch.location(in: scene)
        var touchedNode: SKNode? = scene.atPoint(touchPoint)

        self.touchedNode = touchedNode

        while touchedNode != nil && !(touchedNode is TouchResponder) {
            touchedNode = touchedNode!.parent
        }

        self.touchResponder
            = touchedNode != scene
                ? touchedNode as! TouchResponder?
                : nil
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
        if let handler = self.recognizer {
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

protocol TouchRecognizer {

    var lmiTouches: [LMITouch] { get }

    func discriminate(lmiTouches: [LMITouch]) -> Bool

    func began(lmiTouches: [LMITouch])
    func moved()
    func ended()
    func cancelled()
    func complete()

}

enum TouchRecognizerIndex: Int, CaseIterable {

    case tapRecognizer1
    case tapRecognizer2
    case panRecognizer
    case pinchRecognizer

    static let tapIndices: [TouchRecognizerIndex] = [
        .tapRecognizer1,
        .tapRecognizer2,
    ]

}

class TouchContainer {

    var lmiTouches: [LMITouch]

    init() {
        self.lmiTouches = []
    }

    var count: Int { self.lmiTouches.count }

    func contains(touch: UITouch) -> Bool {
        for lmiTouch in self.lmiTouches {
            if lmiTouch.touch == touch {
                return true
            }
        }

        return false
    }

    func element(touch: UITouch) -> LMITouch? {
        for lmiTouch in self.lmiTouches {
            if lmiTouch.touch == touch {
                return lmiTouch
            }
        }

        return nil
    }

    func add(lmiTouch: LMITouch) {
        guard self.lmiTouches.count < 2 else {
            return
        }

        self.lmiTouches.append(lmiTouch)
    }

    func remove(lmiTouch: LMITouch) {
        self.lmiTouches.removeAll { $0 == lmiTouch }
    }

    func cancelAll() {
        for lmiTouch in self.lmiTouches {
            lmiTouch.recognizer!.cancelled()
            self.lmiTouches.removeAll()
        }
    }

}

class TouchRecognizerManager {

    private static var _default: TouchRecognizerManager?
    static var `default`: TouchRecognizerManager { self._default! }

    static func set(scene: WorldScene, ui: SKNode, character: Character) {
        self._default = TouchRecognizerManager(scene: scene, ui: ui, character: character)
    }

    static func free() { self._default = nil }

    private let scene: WorldScene

    private let logic: Logic

    var touchContainer: TouchContainer { self.logic.touchContainer }
    var panRecognizer: PanRecognizer { self.logic.panRecognizer }
    var pinchRecognizer: PinchRecognizer { self.logic.pinchRecognizer }

    init(scene: WorldScene, ui: SKNode, character: Character) {
        self.scene = scene
        self.logic = Logic(scene: scene, ui: ui, character: character)
    }

    func cancelAllTouches() {
        self.logic.cancelAllTouches()
    }

}

// MARK: - logic
extension TouchRecognizerManager {

    private class Logic {

        let touchContainer: TouchContainer
        let recognizers: [TouchRecognizer]

        var panRecognizer: PanRecognizer {
            return self.recognizers[TouchRecognizerIndex.panRecognizer] as! PanRecognizer
        }

        var pinchRecognizer: PinchRecognizer {
            return self.recognizers[TouchRecognizerIndex.pinchRecognizer] as! PinchRecognizer
        }

        // MARK: init
        init(scene: WorldScene, ui: SKNode, character: Character) {
            self.touchContainer = TouchContainer()
            self.recognizers = [
                TapRecognizer(scene: scene),
                TapRecognizer(scene: scene),
                PanRecognizer(scene: scene, ui: ui, character: character),
                PinchRecognizer(scene: scene, ui: ui, world: scene.worldLayer),
            ]
        }

        func recognizer(containing touch: UITouch) -> TouchRecognizer? {
            for handler in self.recognizers {
                if handler.lmiTouches.contains(where: { $0.touch == touch }) {
                    return handler
                }
            }

            return nil
        }

        func cancelAllTouches() {
            self.touchContainer.cancelAll()
        }

        // MARK: - touch
        func began(_ lmiTouch: LMITouch) {
            self.touchContainer.add(lmiTouch: lmiTouch)

            for index in TouchRecognizerIndex.tapIndices {
                let tapRecognizer = self.recognizers[index]

                guard tapRecognizer.lmiTouches.first == nil else {
                    continue
                }

                if tapRecognizer.discriminate(lmiTouches: [lmiTouch]) {
                    lmiTouch.recognizer = tapRecognizer
                    tapRecognizer.began(lmiTouches: [lmiTouch])
                }

                return
            }
        }

        func moved(_ lmiTouch: LMITouch) {
            if let handler = lmiTouch.recognizer {
                switch handler {
                case is PinchRecognizer:
                    handler.moved()
                    return
                case is PanRecognizer:
                    handler.moved()
                    return
                default:
                    break
                }
            }

            if self.touchContainer.count == 2
                && self.pinchRecognizer.discriminate(lmiTouches: self.touchContainer.lmiTouches) {
                let lmiTouches = self.touchContainer.lmiTouches

                for lmiTouch in lmiTouches {
                    lmiTouch.cancelHandler()
                    lmiTouch.recognizer = self.pinchRecognizer
                }

                self.pinchRecognizer.began(lmiTouches: lmiTouches)

                return
            }

            if self.panRecognizer.discriminate(lmiTouches: [lmiTouch]) {
                lmiTouch.cancelHandler()
                lmiTouch.recognizer = self.panRecognizer

                self.panRecognizer.began(lmiTouches: [lmiTouch])

                return
            }

            if let recognizer = lmiTouch.recognizer {
                recognizer.moved()
            }
        }

        func ended(_ lmiTouch: LMITouch) {
            guard let handler = lmiTouch.recognizer else {
                self.touchContainer.remove(lmiTouch: lmiTouch)
                return
            }

            for lmiTouch in handler.lmiTouches {
                self.touchContainer.remove(lmiTouch: lmiTouch)
            }

            handler.ended()
        }

        func cancelled(_ lmiTouch: LMITouch) {
            guard let handler = lmiTouch.recognizer else {
                self.touchContainer.remove(lmiTouch: lmiTouch)
                return
            }

            for lmiTouch in handler.lmiTouches {
                self.touchContainer.remove(lmiTouch: lmiTouch)
            }

            handler.cancelled()
        }

    }

}

// MARK: - facade
extension TouchRecognizerManager {

    func touchBegan(_ touch: UITouch) {
        guard self.logic.touchContainer.count < 2 else {
            return
        }

        let lmiTouch = LMITouch(touch, scene: self.scene)
        self.logic.began(lmiTouch)

        lmiTouch.update()
    }

    func touchMoved(_ touch: UITouch) {
        guard let lmiTouch = self.touchContainer.element(touch: touch) else {
            return
        }

        self.logic.moved(lmiTouch)

        lmiTouch.update()
    }

    func touchEnded(_ touch: UITouch) {
        guard let lmiTouch = self.touchContainer.element(touch: touch) else {
            return
        }

        self.logic.ended(lmiTouch)
    }

    func touchCancelled(_ touch: UITouch) {
        guard let lmiTouch = self.touchContainer.element(touch: touch) else {
            return
        }

        self.logic.cancelled(lmiTouch)
    }

}

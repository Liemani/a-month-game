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
    static let longTouch = TouchPossible(rawValue: 0x1 << 3)

    static let all = TouchPossible(rawValue: ~Int(0x0))

}

class RecognizerTouch {

    let touch: UITouch
    let bPosition: CGPoint
    let bTime: TimeInterval
    var pTime: TimeInterval
    var recognizer: TouchRecognizer?
    var possible: [TouchRecognizer]
    var touchResponder: TouchResponder?

    init(_ touch: UITouch, scene: SKScene, touchRecognizers: [TouchRecognizer]) {
        self.touch = touch
        self.bPosition = touch.location(in: scene)
        self.bTime = touch.timestamp
        self.pTime = touch.timestamp
        self.possible = touchRecognizers
        self.setTouchResponder(scene: scene)
    }

    private func setTouchResponder(scene: SKScene) {
        let touchPoint = self.touch.location(in: scene)
        var touchResponder: SKNode? = scene.atPoint(touchPoint)

        while touchResponder != nil && !(touchResponder is TouchResponder) {
            touchResponder = touchResponder!.parent
        }

        self.touchResponder = (touchResponder as? TouchResponder)
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

    func velocity(in node: SKNode) -> CGFloat {
        let cPoint = touch.previousLocation(in: node)
        let pPoint = touch.location(in: node)
        let deltaPoint = cPoint - pPoint

        let cTime = self.touch.timestamp
        let deltaTime = cTime - self.pTime

        return deltaPoint.magnitude / deltaTime
    }

}

extension RecognizerTouch: Equatable {

    static func == (lhs: RecognizerTouch, rhs: RecognizerTouch) -> Bool {
        return lhs.touch == rhs.touch
    }

    static func != (lhs: RecognizerTouch, rhs: RecognizerTouch) -> Bool {
        return !(lhs == rhs)
    }

}

extension RecognizerTouch: Hashable {

    func hash(into hasher: inout Hasher) {
        self.touch.hash(into: &hasher)
    }

}

class TouchRecognizer {

    var recognizerTouches: [RecognizerTouch]

    init() {
        self.recognizerTouches = []
    }

    func recognize(recognizerTouch: RecognizerTouch) -> Bool {
        return false
    }

    func free(recognizerTouch: RecognizerTouch) {
    }

    func began() {
    }

}

enum TouchRecognizerIndex: Int, CaseIterable {

    case tapRecognizer1
    case tapRecognizer2
    case panRecognizer
    case pinchRecognizer
    case longTouchRecognizer

    static let tapIndices: [TouchRecognizerIndex] = [
        .tapRecognizer1,
        .tapRecognizer2,
    ]

}

class RecognizerTouchContainer: Sequence {

    var recognizerTouches: [RecognizerTouch]

    var count: Int { self.recognizerTouches.count }

    init() {
        self.recognizerTouches = []
    }

    func contains(touch: UITouch) -> Bool {
        for recognizerTouch in self.recognizerTouches {
            if recognizerTouch.touch == touch {
                return true
            }
        }

        return false
    }

    func element(touch: UITouch) -> RecognizerTouch? {
        for recognizerTouch in self.recognizerTouches {
            if recognizerTouch.touch == touch {
                return recognizerTouch
            }
        }

        return nil
    }

    func add(recognizerTouch: RecognizerTouch) {
        guard self.recognizerTouches.count < 2 else {
            return
        }

        self.recognizerTouches.append(recognizerTouch)
    }

    func remove(recognizerTouch: RecognizerTouch) {
        self.recognizerTouches.removeAll { $0 === recognizerTouch }
    }

    func makeIterator() -> some IteratorProtocol<RecognizerTouch> {
        return self.recognizerTouches.makeIterator()
    }

}

class TouchManager {

    static var `default` = TouchManager()

    private var scene: SKScene!

    private let recognizerTouches: RecognizerTouchContainer
    private var recognizers: [TouchRecognizer]
    private var timeoutRecognizers: [TouchRecognizer]

    init() {
        self.recognizerTouches = RecognizerTouchContainer()
        self.recognizers = []
        self.timeoutRecognizers = []
    }

    func set(scene: SKScene, recognizers: [TouchRecognizer]) {
        self.scene = scene
        self.recognizers = recognizers
        var timeoutRecognizers: [TouchRecognizer] = []

        for recognizer in recognizers {
            if recognizer is LongTouchRecognizer {
                timeoutRecognizers.append(recognizer)
            }
        }

        self.timeoutRecognizers = timeoutRecognizers
    }

    func cancelAllTouches() {
        for recognizerTouch in recognizerTouches {
            self.touchCancelled(recognizerTouch.touch)
        }
    }

    private func recognize(recognizerTouch: RecognizerTouch) {
        for recognizer in recognizerTouch.possible {
            if self.recognize(recognizer: recognizer,
                                    recognizerTouch: recognizerTouch) {
                return
            }
        }
    }

    func updateTimeoutRecognizer() {
        for recognizerTouch in self.recognizerTouches {
            for recognizer in recognizerTouch.possible {
                guard recognizer is TimeRecognizer else { continue }

                if self.recognize(recognizer: recognizer,
                                        recognizerTouch: recognizerTouch) {
                    return
                }
            }
        }
    }

    // MARK: - logic
    func recognize(recognizer: TouchRecognizer,
                   recognizerTouch: RecognizerTouch) -> Bool {
        if recognizer.recognize(recognizerTouch: recognizerTouch) {
            TouchLogics.default.cancelled(recognizerTouch.touch)

            if let pRecognizer = recognizerTouch.recognizer {
                pRecognizer.free(recognizerTouch: recognizerTouch)
            }

            recognizerTouch.recognizer = recognizer
            recognizerTouch.possible.removeAll { $0 === recognizer }

            recognizerTouch.recognizer!.began()

            return true
        }

        return false
    }

    func removePossible(from recognizerTouch: RecognizerTouch,
                        recognizer: TouchRecognizer) {
        recognizerTouch.possible.removeAll { $0 === recognizer }
        recognizer.free(recognizerTouch: recognizerTouch)
    }

    func removePossible(from recognizerTouch: RecognizerTouch,
                        where shouldBeRemoved: (TouchRecognizer) -> Bool) {
        recognizerTouch.possible.removeAll { recognizer in
            if shouldBeRemoved(recognizer) {
                recognizer.free(recognizerTouch: recognizerTouch)

                return true
            } else {
                return false
            }
        }
    }

    func recognizerTouchEnded(recognizerTouch: RecognizerTouch) {
        for recognizer in self.recognizers {
            recognizer.free(recognizerTouch: recognizerTouch)
        }

        recognizerTouch.recognizer = nil

        TouchLogics.default.ended(recognizerTouch.touch)
    }

    func recognizerTouchCancelled(recognizerTouch: RecognizerTouch) {
        for recognizer in self.recognizers {
            recognizer.free(recognizerTouch: recognizerTouch)
        }

        recognizerTouch.recognizer = nil

        TouchLogics.default.cancelled(recognizerTouch.touch)
    }

    // MARK: - facade
    func touchBegan(_ touch: UITouch) {
        guard self.recognizerTouches.count < 2 else {
            return
        }

        let recognizerTouch = RecognizerTouch(touch, scene: self.scene, touchRecognizers: self.recognizers)
        self.recognizerTouches.add(recognizerTouch: recognizerTouch)

        self.recognize(recognizerTouch: recognizerTouch)

        recognizerTouch.update()
    }

    func touchMoved(_ touch: UITouch) {
        guard let recognizerTouch = self.recognizerTouches.element(touch: touch) else {
            return
        }

        self.recognize(recognizerTouch: recognizerTouch)

        recognizerTouch.update()

        TouchLogics.default.moved(recognizerTouch.touch)
    }

    func touchEnded(_ touch: UITouch) {
        guard let recognizerTouch = self.recognizerTouches.element(touch: touch) else {
            return
        }

        self.recognizerTouchEnded(recognizerTouch: recognizerTouch)

        self.complete(recognizerTouch)
    }

    func touchCancelled(_ touch: UITouch) {
        guard let recognizerTouch = self.recognizerTouches.element(touch: touch) else {
            return
        }

        self.recognizerTouchCancelled(recognizerTouch: recognizerTouch)

        self.complete(recognizerTouch)
    }

    func complete(_ recognizerTouch: RecognizerTouch) {
        self.recognizerTouches.remove(recognizerTouch: recognizerTouch)
    }

}

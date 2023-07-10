//
//  ButtonNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {

    private let eventType: EventType

    init(texture: SKTexture, frame: CGRect, text: String?, eventType: EventType) {
        self.eventType = eventType

        super.init(texture: texture, color: .white, size: frame.size)

        self.position = frame.origin
        self.size = frame.size

        let label = SKLabelNode()

        label.text = text
        label.fontSize = self.size.height / 2.0
        label.position = CGPoint(x: 0, y: -label.fontSize / 2.0)
        label.zPosition = 1.0

        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - activate
    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

}

extension Button: TouchResponder {

    func touchBegan(_ touch: UITouch) {
        self.activate()
    }

    func touchMoved(_ touch: UITouch) {
        if self.isBeing(touched: touch) {
            self.activate()
        } else {
            self.deactivate()
        }
    }

    func touchEnded(_ touch: UITouch) {
        if self.isBeing(touched: touch) {
            let event = Event(type: self.eventType,
                              udata: nil,
                              sender: self)
            event.manager.enqueue(event)
        }

        self.completeTouch(touch)
    }

    func touchCancelled(_ touch: UITouch) {
        self.completeTouch(touch)
    }

    func completeTouch(_ touch: UITouch) {
        self.deactivate()
    }

    func longTouched(_ touch: UITouch) {
    }

}

extension Button {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.touchBegan(touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.touchMoved(touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.touchEnded(touch)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.touchCancelled(touch)
    }

}

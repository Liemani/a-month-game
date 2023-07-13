//
//  ButtonNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode {

    let eventType: EventType
    var shouldActivated: Bool

    init(texture: SKTexture?, frame: CGRect, text: String?, eventType: EventType) {
        self.eventType = eventType
        self.shouldActivated = true

        super.init(texture: texture, color: .white, size: frame.size)

        self.position = frame.origin
        self.size = frame.size

        if let text = text {
            let label = SKLabelNode()

            label.text = text
            label.fontSize = self.size.height / 2.0
            label.position = CGPoint(x: 0, y: -label.fontSize / 2.0)
            label.zPosition = 1.0

            self.addChild(label)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - activate
    func activate() {
        self.alpha = self.shouldActivated ? 0.5 : self.alpha
    }

    func deactivate() {
        self.alpha = self.shouldActivated ? 1.0 : self.alpha
    }

}

extension Button: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is TapRecognizer.Type:
            return true
        default:
            return false
        }
    }

}

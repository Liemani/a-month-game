//
//  ButtonNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

class Button: SKSpriteNode, TouchResponder {

    let eventType: EventType

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

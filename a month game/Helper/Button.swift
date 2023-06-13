//
//  Button.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/30.
//

import Foundation
import SpriteKit

protocol ButtonDelegate: AnyObject {

    func buttonTapped(sender: Any?)

}

class Button: SpriteNode {

    weak var delegate: ButtonDelegate?

    func setUp() {
        self.isUserInteractionEnabled = true

        let label = SKLabelNode()
        label.position = CGPoint(x: 0, y: -label.fontSize / 2.0)
        label.zPosition = 1.0
        self.addChild(label)
    }

    func set(frame: CGRect) {
        self.position = frame.origin
        self.size = frame.size

        let label = self.children[0] as! SKLabelNode
        label.fontSize = self.size.height / 2.0
    }

    func set(text: String) {
        let label = self.children[0] as! SKLabelNode
        label.text = text
    }

    // MARK: - activate
    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    // MARK: - touch
    var touch: UITouch? = nil

    override func touchBegan(_ touch: UITouch) {
        if self.touch == nil {
            self.activate()
            self.touch = touch
        }
    }

    override func touchMoved(_ touch: UITouch) {
        guard touch == self.touch else { return }

        if self.isAtLocation(of: touch) {
            self.activate()
        } else {
            self.deactivate()
        }
    }

    override func touchEnded(_ touch: UITouch) {
        guard touch == self.touch else { return }

        if self.isAtLocation(of: touch) {
            self.delegate!.buttonTapped(sender: self)
        }
        self.resetTouch(touch)
    }

    override func touchCancelled(_ touch: UITouch) {
        guard touch == self.touch else { return }

        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        self.deactivate()
        self.touch = nil
    }

}

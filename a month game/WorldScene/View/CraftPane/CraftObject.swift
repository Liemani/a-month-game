//
//  CraftObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftObject: SKSpriteNode {

    var goType: GameObjectType = .none

    func setUp() {
        self.isUserInteractionEnabled = true
        self.size = Constant.defaultNodeSize
        self.zPosition = Constant.ZPosition.craftObject
    }

    func set(_ goType: GameObjectType) {
        self.texture = goType.texture
    }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    // MARK: touch
    override func touchBegan(_ touch: UITouch) {
    }

    override func touchMoved(_ touch: UITouch) {
    }

    override func touchEnded(_ touch: UITouch) {
    }

    override func touchCancelled(_ touch: UITouch) {
    }

    override func resetTouch(_ touch: UITouch) {
    }

    // MARK: - override
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchBegan(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchMoved(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchEnded(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.touchCancelled(touch) }
    }

}

class CraftObjectTouch: TouchModel {

}

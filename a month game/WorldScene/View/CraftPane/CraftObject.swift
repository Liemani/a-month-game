//
//  CraftObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftObject: SKSpriteNode {

    var craftPane: CraftPane { self.parent?.parent as! CraftPane }

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
        guard self.goType != .none else {
            return
        }

        let result = self.touchManager.add(CraftObjectTouch(touch: touch, sender: self))

        if result == true {
            self.activate()
        }
    }

    override func touchMoved(_ touch: UITouch) {
        guard let touchModel = self.touchManager.first(from: touch) else {
            return
        }

        guard touchModel.sender == self else {
            touchModel.sender.touchMoved(touch)
            return
        }

        guard !self.isAtLocation(of: touch) else {
             return
        }

        if !self.worldScene.thirdHand.isEmpty {
            self.touchCancelled(touch)
            return
        }

        self.craftPane.craft(self.goType)
        let craftedGO = self.worldScene.thirdHand.gameObject!

        self.resetTouch(touch)
        self.touchManager.add(GameObjectTouch(touch: touch, sender: craftedGO))
    }

    override func touchEnded(_ touch: UITouch) {
        guard let touchModel = self.touchManager.first(from: touch) else {
            return
        }

        guard touchModel.sender == self else {
            touchModel.sender.touchMoved(touch)
            return
        }

        // TODO: implement
        self.resetTouch(touch)
    }

    override func touchCancelled(_ touch: UITouch) {
        guard let touchModel = self.touchManager.first(from: touch) else {
            return
        }

        guard touchModel.sender == self else {
            touchModel.sender.touchMoved(touch)
            return
        }

        // TODO: implement
        self.resetTouch(touch)
    }

    override func resetTouch(_ touch: UITouch) {
        self.deactivate()
        self.touchManager.removeFirst(from: touch)
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

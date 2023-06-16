//
//  LMINode.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

class LMINode: SKNode, LMITouchable {

    var worldScene: WorldScene { self.scene as! WorldScene }
    var touchManager: WorldSceneTouchManager { self.worldScene.touchManager }
    var interactionZone: InteractionZone { self.worldScene.interactionZone }

    func touchBegan(_ touch: UITouch) {}
    func touchMoved(_ touch: UITouch) {}
    func touchEnded(_ touch: UITouch) {}
    func touchCancelled(_ touch: UITouch) {}
    func resetTouch(_ touch: UITouch) {}

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

//
//  Extension.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/18.
//

import Foundation
import SpriteKit

extension SKNode {

    func child(at touch: UITouch) -> SKNode? {
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)

        return touchedNodes.first
    }

}

extension UITouch {

    func `is`(onThe node: SKNode) -> Bool {
        guard let parent = node.parent else { return true }

        let touchLocation = self.location(in: parent)

        return node.contains(touchLocation)
    }

}

//
//  WorldLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/11.
//

import Foundation
import SpriteKit

class WorldLogic {

    private let world: SKNode

    init(world: SKNode) {
        self.world = world
    }

    var scale: Double {
        get { self.world.xScale }
        set {
            self.world.xScale = newValue
            self.world.yScale = newValue
        }
    }

}

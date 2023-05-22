//
//  GameObjectPineTree.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/17.
//

import Foundation

final class GameObjectPineTree: GameObject {

    // MARK: - override
    override var isWalkable: Bool { return false }
    override var isPickable: Bool { return false }

}

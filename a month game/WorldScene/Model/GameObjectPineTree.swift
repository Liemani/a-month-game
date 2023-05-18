//
//  GameObjectPineTree.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/17.
//

import Foundation

final class GameObjectPineTree: GameObject {

    required init(id: Int?, coordinate: GameObjectCoordinate) {
        super.init(id: id, coordinate: coordinate)
    }

    // MARK: - override
    override var isWalkable: Bool { return false }

}

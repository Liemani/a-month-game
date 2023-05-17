//
//  GameObjectWoodWall.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/17.
//

import Foundation

final class GameObjectWoodWall: GameObject {

    required init(id: Int?, coordinate: GameObjectCoordinate) {
        super.init(id: id, coordinate: coordinate)
    }

    // MARK: - override
    override class var isWalkable: Bool { return false }

    override func interact(leftHand: GameObject?, rightHand: GameObject?) {
        print("This is a instance of GameObjectWoodWall")
    }

}

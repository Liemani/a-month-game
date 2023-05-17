//
//  GameObjectPineCone.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

final class GameObjectPineCone: GameObject {

    required init(id: Int?, coordinate: GameObjectCoordinate) {
        super.init(id: id, coordinate: coordinate)
    }

    // MARK: - override
    override func interact(leftHand: GameObject?, rightHand: GameObject?) {
        print("This is a instance of GameObjectPineCone")
    }

}

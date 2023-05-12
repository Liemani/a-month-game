//
//  GameItem.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameItem {

    static var nextID: Int = 0

    let typeID: Int
    let id: Int
    var position: (inventoryID: Int, row: Int, column: Int)

    init(typeID: Int) {
        self.typeID = typeID

        id = GameItem.nextID
        GameItem.nextID += 1

        self.position = (0, 0, 0)
    }

}

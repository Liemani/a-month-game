//
//  GameItem.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameObject {

    static private let idGenerator = IDGenerator.default

    let id: Int
    var position: GameObjectPosition
    let typeID: Int

    init(position: GameObjectPosition, typeID: Int, id: Int?) {
        self.id = id ?? GameObject.idGenerator.generate()
        self.typeID = typeID
        self.position = position
    }

    required convenience init(position: GameObjectPosition, id: Int?) {
        self.init(position: position, typeID: 0, id: id)
    }

}

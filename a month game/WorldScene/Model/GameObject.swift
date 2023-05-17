//
//  GameObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameObject {

    static private let idGenerator = IDGenerator.default

    let id: Int
    var coordinate: GameObjectCoordinate

    static func new(withTypeID typeID: Int, id: Int?, coordinate: GameObjectCoordinate) -> GameObject {
        let typeID = Resource.gameObjectTypeIDToInformation.indices.contains(typeID) ? typeID : 0
        return Resource.gameObjectTypeIDToInformation[typeID].gameObjectType.init(id: id, coordinate: coordinate)
    }

    required init(id: Int?, coordinate: GameObjectCoordinate) {
        self.id = id ?? GameObject.idGenerator.generate()
        self.coordinate = coordinate
    }

    // MARK: - property to be overriden
    class var isWalkable: Bool { return true }

    func interact(leftHand: GameObject?, rightHand: GameObject?) { }

}

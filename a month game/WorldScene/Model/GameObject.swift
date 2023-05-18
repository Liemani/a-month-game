//
//  GameObject.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

/// Call gameObjectDelegate.initDelegateReference() before call gameObject.interact()
protocol GameObjectDelegate {

    func interact(_ gameObject: GameObject, with leftHand: GameObject?, and rightHand: GameObject?)

}

extension GameObjectDelegate {

    func initDelegateReference() { GameObject.delegate = self }

}

// MARK: - class GameObject
class GameObject {

    let id: Int
    var coordinate: GameObjectCoordinate

    required init(id: Int?, coordinate: GameObjectCoordinate) {
        self.id = id ?? GameObject.idGenerator.generate()
        self.coordinate = coordinate
    }

    func interact(leftHand: GameObject?, rightHand: GameObject?) {
        GameObject.delegate.interact(self, with: leftHand, and: rightHand)
    }

    // MARK: property to be overriden
    var isWalkable: Bool { return true }

}

extension GameObject {

    static private let idGenerator = IDGenerator.default

    static var delegate: GameObjectDelegate!

    static func new(withTypeID typeID: Int, id: Int?, coordinate: GameObjectCoordinate) -> GameObject {
        let typeID = Resource.gameObjectTypeIDToInformation.indices.contains(typeID) ? typeID : 0
        return Resource.gameObjectTypeIDToInformation[typeID].gameObjectType.init(id: id, coordinate: coordinate)
    }

}

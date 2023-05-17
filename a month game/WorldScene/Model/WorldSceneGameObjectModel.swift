//
//  WorldSceneGameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

final class WorldSceneGameObjectModel {

    weak var worldSceneModel: WorldSceneModel!

    var gameObjectDictionary: Dictionary<Int, GameObject>

    // MARK: - init
    init(worldSceneModel: WorldSceneModel, gameObjectDictionary: Dictionary<Int, GameObject>) {
        self.worldSceneModel = worldSceneModel

        self.gameObjectDictionary = gameObjectDictionary
    }

    // MARK: - edit object
    func add(gameObject: GameObject) {
        self.gameObjectDictionary[gameObject.id] = gameObject
    }

    func remove(gameObject: GameObject) {
        self.gameObjectDictionary.removeValue(forKey: gameObject.id)
    }

}

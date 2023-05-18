//
//  WorldSceneGameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

final class WorldSceneGameObjectModel {

    var gameObjectDictionary: Dictionary<Int, GameObject>

    // MARK: - init
    init(gameObjectDictionary: Dictionary<Int, GameObject>) {
        self.gameObjectDictionary = gameObjectDictionary
    }

    // MARK: - edit object
    func add(_ gameObject: GameObject) {
        self.gameObjectDictionary[gameObject.id] = gameObject
    }

    func remove(_ gameObject: GameObject) {
        self.gameObjectDictionary.removeValue(forKey: gameObject.id)
    }

}

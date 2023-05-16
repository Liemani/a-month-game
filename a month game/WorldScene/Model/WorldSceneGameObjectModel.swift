//
//  GameItemModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

final class WorldSceneGameObjectModel {

    weak var worldSceneModel: WorldSceneModel!

    var gameObjectDictionary: Dictionary<Int, GameObject>

    // MARK: - init
    init(worldSceneModel: WorldSceneModel, gameItemDictionary: Dictionary<Int, GameObject>) {
        self.worldSceneModel = worldSceneModel

        self.gameObjectDictionary = gameItemDictionary
    }

    // MARK: - edit item
    func add(gameItem: GameObject) {
        self.gameObjectDictionary[gameItem.id] = gameItem
    }

    func remove(gameItem: GameObject) {
        self.gameObjectDictionary.removeValue(forKey: gameItem.id)
    }

}

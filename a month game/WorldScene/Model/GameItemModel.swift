//
//  GameItemModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/12.
//

import Foundation

class GameItemModel {

    weak var worldModel: WorldModel!

    var gameItemDictionary: Dictionary<Int, GameItem>

    // MARK: - init
    init(worldModel: WorldModel) {
        self.worldModel = worldModel

        self.gameItemDictionary = Dictionary<Int, GameItem>()

        let seed = GameItemSeedPineCone()
        seed.position = (0, 50, 50)
        addGameItem(gameItem: seed)
    }

    // MARK: - add item
    func addGameItem(gameItem: GameItem) {
        gameItemDictionary[gameItem.id] = gameItem
    }

}

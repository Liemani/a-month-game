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
    init(worldModel: WorldModel, gameItemDictionary: Dictionary<Int, GameItem>) {
        self.worldModel = worldModel

        self.gameItemDictionary = gameItemDictionary
    }

    func setGameItemCustom() {
        let seed = GameItemSeedPineCone()
        seed.position = (0, 50, 50)
        addGameItem(gameItem: seed)
    }

    // MARK: - add item
    func addGameItem(gameItem: GameItem) {
        self.gameItemDictionary[gameItem.id] = gameItem
        self.worldModel.storeGameItemToData(gameItem: gameItem)
    }

}

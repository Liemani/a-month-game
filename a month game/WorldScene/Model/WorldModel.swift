//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class WorldModel {

    var diskController: DiskController!

    weak var worldController: WorldSceneController!

    var tileMapModel: TileMapModel!
    var gameItemModel: GameItemModel!

    init(worldController: WorldSceneController, worldName: String) {
        let diskController = DiskController.default
        diskController.setToWorld(ofName: worldName)
        self.diskController = diskController

        self.worldController = worldController

        let tileMapData = diskController.loadTileData()
        self.tileMapModel = TileMapModel(worldModel: self, tileMapData: tileMapData)

        let gameItemDictionary = diskController.loadGameItemDictionary()
        self.gameItemModel = GameItemModel(worldModel: self, gameItemDictionary: gameItemDictionary)
    }

    deinit {
        diskController.closeFiles()
    }

    func saveTileData(row: Int, column: Int, tileData: Data) {
        self.diskController.saveTileData(row: row, column: column, tileData: tileData)
    }

    func storeGameItemToData(gameItem: GameItem) {
        self.diskController.storeGameItem(gameItem: gameItem)

    }

}

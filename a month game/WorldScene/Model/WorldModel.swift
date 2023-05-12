//
//  GameModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation

class WorldModel {

    weak var worldController: WorldSceneController!
    var fileController: FileController!
    var tileMapModel: TileMapModel!

    var isMenuOpen: Bool {
        return !self.worldController.worldScene.menuLayer.isHidden
    }

    init(worldController: WorldSceneController, worldName: String) {
        self.worldController = worldController
        self.fileController = FileController(worldName: Constant.defaultWorldName)
        let tileMapData = self.fileController.loadTileMapData()
        self.tileMapModel = TileMapModel(worldModel: self, tileMapData: tileMapData)
    }

    func saveTileData(index: Int, tileData: Data) {
        self.fileController.saveTileData(index: index, tileData: tileData)
    }

}

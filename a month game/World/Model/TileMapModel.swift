//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

class TileMapModel {

    weak var worldModel: WorldModel!

    var tileMapData: Data!
    var tileMap: UnsafeMutableBufferPointer<Int>!

    // MARK: - init
    init(worldModel: WorldModel, tileMapData: Data) {
        self.worldModel = worldModel

        setTileMapData(tileMapData: tileMapData)
        setTileCustom()
    }

    func setTileMapData(tileMapData: Data) {
        self.tileMapData = tileMapData
        tileMap = self.tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

    func setTileCustom() {
        setTile(row: 45, column: 45, tileID: 1)
        setTile(row: 48, column: 48, tileID: 2)
        setTile(row: 52, column: 52, tileID: 2)
        setTile(row: 52, column: 53, tileID: 2)
    }

    // MARK: - set tile
    func setTile(row: Int, column: Int, tileID: Int) {
        self.tileMap[100 * row + column] = tileID
        saveTile(row: row, column: column, tileID: tileID)
    }

    func saveTile(row: Int, column: Int, tileID: Int) {
        var value = tileID
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        worldModel.saveTileData(index: Constant.gridSize * row + column, tileData: tileData)
    }

}

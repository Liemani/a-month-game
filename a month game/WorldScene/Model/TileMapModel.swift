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

        self.setTileMapData(tileMapData: tileMapData)
        self.test()
    }

    func setTileMapData(tileMapData: Data) {
        self.tileMapData = tileMapData
        tileMap = self.tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

    func test() {
        self.setTile(row: 45, column: 45, tileID: 1)
        self.setTile(row: 48, column: 48, tileID: 2)
        self.setTile(row: 52, column: 52, tileID: 2)
        self.setTile(row: 52, column: 53, tileID: 2)
    }

    // MARK: - set tile
    func setTile(row: Int, column: Int, tileID: Int) {
        self.tileMap[100 * row + column] = tileID
        self.saveTile(row: row, column: column, tileID: tileID)
    }

    func saveTile(row: Int, column: Int, tileID: Int) {
        var value = tileID
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.worldModel.saveTileData(row: row, column: column, tileData: tileData)
    }

}

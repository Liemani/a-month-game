//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

final class WorldSceneTileModel {

    var tileMapData: Data!
    var tileMap: UnsafeMutableBufferPointer<Int>!

    // MARK: - init
    init(tileMapData: Data) {
        set(tileMapData: tileMapData)
    }

    // MARK: - get set
    func getTileTypeID(row: Int, column: Int) -> Int {
        return self.tileMap[100 * row + column]
    }

    func set(row: Int, column: Int, tileTypeID: Int) {
        self.tileMap[100 * row + column] = tileTypeID
    }

    // MARK: - set tile map data
    private func set(tileMapData data: Data) {
        self.tileMapData = data
        tileMap = self.tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

}

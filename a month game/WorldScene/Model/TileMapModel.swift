//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

final class TileMapModel {

    var tileMapData: Data!
    var tileMap: UnsafeMutableBufferPointer<Int>!

    // MARK: - init
    init(tileMapData: Data) {
        set(tileMapData: tileMapData)
    }

    // MARK: - get set
    // TODO: change argument to coordinate
    func tileType(atX x: Int, y: Int) -> TileType {
        return TileType(rawValue: self.tileMap[Constant.gridSize * x + y]) ?? .grass
    }

    // TODO: what about get tileType and coordinate as argument?
    func set(tileType: Int, toX x: Int, y: Int) {
        self.tileMap[Constant.gridSize * x + y] = tileType
    }

    // MARK: - set tile map data
    private func set(tileMapData data: Data) {
        self.tileMapData = data
        tileMap = self.tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

}

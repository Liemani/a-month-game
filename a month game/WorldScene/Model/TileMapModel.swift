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
    func tileType(atX x: Int, y: Int) -> TileType {
        let index = Constant.gridSize * x + y
        return TileType(rawValue: self.tileMap[index]) ?? .grass
    }

    func tileType(at tileCoordinate: TileCoordinate) -> TileType {
        let coordinate = tileCoordinate.coordinate
        return self.tileType(atX: coordinate.x, y: coordinate.y)
    }

    func set(tileType: Int, toX x: Int, y: Int) {
        let index = Constant.gridSize * x + y
        self.tileMap[index] = tileType
    }

    func set(tileType: Int, at tileCoordinate: TileCoordinate) {
        let coordinate = tileCoordinate.coordinate
        let index = Constant.gridSize * coordinate.x + coordinate.y
        self.tileMap[index] = tileType
    }

    // MARK: - set tile map data
    private func set(tileMapData data: Data) {
        self.tileMapData = data
        tileMap = self.tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

}

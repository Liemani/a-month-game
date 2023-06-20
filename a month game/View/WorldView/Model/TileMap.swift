//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

final class TileMap {

    private let tileRepository: TileRepository

    private var tileMapData: Data

    // MARK: - init
    init(tileRepository: TileRepository) {
        self.tileRepository = tileRepository
        self.tileMapData = tileRepository.loadTileMap()
    }

    // MARK: - edit
    #warning("not good")
    func tile(_ x: Int, _ y: Int) -> TileType {
        let tileType = self.tileRepository.load(x, y)
        return tileType ?? TileType(rawValue: 0)!
    }

    func tile(at coord: Coordinate<Int>) -> TileType {
        return self.tile(coord.x, coord.y)
    }

    func update(type: TileType, toX x: Int, y: Int) {
        self.tileRepository.update(type: type, toX: x, y: y)
    }

    func update(type: TileType, to coord: Coordinate<Int>) {
        self.update(type: type, toX: coord.x, y: coord.y)
    }

    var tilesMapDataPointer: UnsafeBufferPointer<Int> {
        let tileMapBufferPointer = self.tileMapData.withUnsafeBytes { $0.bindMemory(to: Int.self) }
        return tileMapBufferPointer
    }

}

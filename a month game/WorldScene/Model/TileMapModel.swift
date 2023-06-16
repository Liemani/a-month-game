//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

final class TileMapModel {

    private let service: TileService

    // MARK: - init
    init(tileService: TileService) {
        self.service = tileService
    }

    // MARK: - edit
    func tile(_ x: Int, _ y: Int) -> TileType {
        let tileType = self.service.load(x, y)
        return tileType ?? TileType(rawValue: 0)!
    }

    func tile(at tileCoord: TileCoordinate) -> TileType {
        return self.tile(tileCoord.x, tileCoord.y)
    }

    func update(type: TileType, toX x: Int, y: Int) {
        self.service.update(type: type, toX: x, y: y)
    }

    func update(type: TileType, to tileCoord: TileCoordinate) {
        self.update(type: type, toX: tileCoord.x, y: tileCoord.y)
    }

    // TODO: remove
    func tilesMap() -> Data {
        return self.service.loadTileMap()
    }

}

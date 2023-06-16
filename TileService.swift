//
//  TileService.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation

final class TileService {

    private let tileRepository: TileRepository

    init(worldDirectoryURL: URL) {
        self.tileRepository = TileRepository(worldDirectoryURL: worldDirectoryURL)
    }

    func loadTileMap() -> Data {
        return self.tileRepository.loadTileMap()
    }

    func load(_ x: Int, _ y: Int) -> TileType? {
        let index = Constant.gridSize * x + y
        let tileData = self.tileRepository.load(at: index)
        let tileRawValue = tileData.withUnsafeBytes { $0.load(as: Int.self) }
        return TileType(rawValue: tileRawValue)
    }

    func update(tileType: TileType, toX x: Int, y: Int) {
        var value = tileType.rawValue
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        let index = Constant.gridSize * x + y
        self.tileRepository.update(tileData: tileData, toIndex: index)
    }

}

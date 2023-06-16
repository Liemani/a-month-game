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
        return self.tileRepository.readTileMap()
    }

    func load(_ x: Int, _ y: Int) -> TileType? {
        let index = Constant.gridSize * x + y
        let tileData = self.tileRepository.read(at: index)
        let tileRawValue = tileData.withUnsafeBytes { $0.load(as: Int.self) }
        return TileType(rawValue: tileRawValue)
    }

    func update(type: TileType, toX x: Int, y: Int) {
        var value = type.rawValue
        let tileData = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        let index = Constant.gridSize * x + y
        self.tileRepository.update(tileData: tileData, to: index)
    }

}

//
//  WorldDataService.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation

enum WorldDataIndex: Int, CaseIterable {

    case nextID
    case characterPositionX
    case characterPositionY

}

class WorldDataRepository {

    private let worldDataDataSource: WorldDataDataSource

    init(worldDirectoryURL: URL) {
        self.worldDataDataSource = WorldDataDataSource(worldDirectoryURL: worldDirectoryURL)
    }

    func load(at index: WorldDataIndex) -> Int {
        let data = self.worldDataDataSource.read(at: index.rawValue)
        return data.withUnsafeBytes { $0.load(as: Int.self) }
    }

    func update(value: Int, to index: WorldDataIndex) {
        var value = value
        let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        self.worldDataDataSource.update(data: data, to: index.rawValue)
    }

}

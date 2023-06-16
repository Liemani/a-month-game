//
//  TileFileController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import Foundation

final class TileRepository {

    private let fileManager: FileManager

    private var filePath: String!
    private var updateFileHandle: FileHandle!

    init(worldDirectoryURL: URL) {
        self.fileManager = FileManager.default

        // TODO: URL.path is deprecated
        let filePath = worldDirectoryURL.appending(path: Constant.tileMapFileName).path
        self.filePath = filePath

        self.createTileDataFileIfNotExist()

        self.updateFileHandle = FileHandle(forUpdatingAtPath: filePath)
    }

    func loadTileMap() -> Data {
        try! self.updateFileHandle.seek(toOffset: 0)
        return try! self.updateFileHandle.readToEnd()!
    }

    func load(at index: Int) -> Data {
        try! self.updateFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        return try! self.updateFileHandle.read(upToCount: MemoryLayout<Int>.size)!
    }

    func update(tileData: Data, toIndex index: Int) {
        try! self.updateFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        try! self.updateFileHandle.write(contentsOf: tileData)
    }

}

// MARK: - private
extension TileRepository {

    private func createTileDataFileIfNotExist() {
        guard !self.fileManager.fileExists(atPath: self.filePath) else {
            return
        }

        let tileMapData = Data(count: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize)
        self.fileManager.createFile(atPath: self.filePath, contents: tileMapData)
    }

}

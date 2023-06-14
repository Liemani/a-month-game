//
//  TileMapFileController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import Foundation

final class TileMapRepository {

    private let fileManager: FileManager

    private var filePath: String!
    private var writeFileHandle: FileHandle!

    init(worldDirectoryURL: URL) {
        self.fileManager = FileManager.default

        // TODO: URL.path is deprecated
        let filePath = worldDirectoryURL.appending(path: Constant.tileMapFileName).path
        self.filePath = filePath

        createTileDataFileIfNotExist()

        let fileHandle = FileHandle(forWritingAtPath: filePath)
        self.writeFileHandle = fileHandle
    }

    func close() {
        self.writeFileHandle.closeFile()
    }

    /// Load Data from the file
    func loadTileMapData() -> Data {
        let readFileHandle = FileHandle(forReadingAtPath: self.filePath)!
        let tileMapData = try! readFileHandle.readToEnd()

        readFileHandle.closeFile()

        return tileMapData!
    }

    /// Save tile data to the file by index
    func save(tileData: Data, toIndex index: Int) {
        try! self.writeFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        try! self.writeFileHandle.write(contentsOf: tileData)
    }

    // MARK: - private
    private func createTileDataFileIfNotExist() {
        guard !self.fileManager.fileExists(atPath: self.filePath) else { return }

        let tileMapData = self.generateInitialTileMapData()
        self.fileManager.createFile(atPath: self.filePath, contents: tileMapData)
    }

    private func generateInitialTileMapData() -> Data {
        var tileMapData = Data(count: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize)

        let tileMap = tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
        self.set(tileMap: tileMap, tileType: 1, x: Constant.centerTileIndex, y: Constant.centerTileIndex)

        return tileMapData
    }

    private func set(tileMap: UnsafeMutableBufferPointer<Int>, tileType: Int, x: Int, y: Int) {
        tileMap[Constant.gridSize * x + y] = tileType
    }

}

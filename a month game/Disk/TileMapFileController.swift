//
//  TileMapFileController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import Foundation

final class TileMapFileController {

    private let fileManager: FileManager

    private var filePath: String!
    private var writeFileHandle: FileHandle!

    init() {
        self.fileManager = FileManager.default
    }

    /// Call this function before calling load and save method
    func setToWorld(with directoryURL: URL) {
        // NOTE: URL.path is deprecated
        let filePath = directoryURL.appending(path: Constant.tileMapFileName).path
        self.filePath = filePath

        createTileDataFileIfNotExist(ofPath: filePath)

        let fileHandle = FileHandle(forWritingAtPath: filePath)
        self.writeFileHandle = fileHandle
    }

    /// Load Data from the file
    func loadTileMapData() -> Data {
        let readFileHandle = FileHandle(forReadingAtPath: self.filePath)!
        let tileMapData = try! readFileHandle.readToEnd()

        readFileHandle.closeFile()

        return tileMapData!
    }

    /// Save tile data to the file by index
    func saveTileData(index: Int, tileData: Data) {

        try! self.writeFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        try! self.writeFileHandle.write(contentsOf: tileData)
    }

    /// Call closeFile() when you saved all tile
    func closeWriteFile() {
        writeFileHandle.closeFile()
    }

    // MARK: - private
    private func createTileDataFileIfNotExist(ofPath filePath: String) {
        guard !self.fileManager.fileExists(atPath: filePath) else { return }

        let tileMapData = self.getInitialTileMapData()
        self.fileManager.createFile(atPath: filePath, contents: tileMapData)
    }

    private func getInitialTileMapData() -> Data {
        var tileMapData = Data(count: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize)

        var tileMap = tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
        self.set(tileMap: tileMap, row: 45, column: 45, tileTypeID: 1)
        self.set(tileMap: tileMap, row: 48, column: 48, tileTypeID: 2)
        self.set(tileMap: tileMap, row: 52, column: 52, tileTypeID: 2)
        self.set(tileMap: tileMap, row: 52, column: 53, tileTypeID: 2)

        return tileMapData
    }

    private func set(tileMap: UnsafeMutableBufferPointer<Int>, row: Int, column: Int, tileTypeID: Int) {
        tileMap[100 * row + column] = tileTypeID
    }

}

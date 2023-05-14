//
//  FileController.swift
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
        if !self.fileManager.fileExists(atPath: filePath) {
            self.fileManager.createFile(atPath: filePath, contents: Data(count: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize))
        }
    }

}

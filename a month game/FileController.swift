//
//  FileController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

import Foundation

class FileController {

    let fileManager: FileManager
    var worldDirectoryURL: URL!
    var tileMapDataFileURL: URL!

    // MARK: - init
    init(worldName: String) {
        self.fileManager = FileManager.default

        self.set(by: worldName)
    }

    func set(by worldName: String) {
        self.worldDirectoryURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: worldName)
        self.tileMapDataFileURL = self.worldDirectoryURL.appending(path: Constant.tileMapFileName)
    }

    // MARK: - modify world data
    private func createWorldDataIfNotExist() {
        createWorldDirectoryIfNotExist()
        createTileDataFileIfNotExist()
    }

    private func createWorldDirectoryIfNotExist() {
        if !self.fileManager.fileExists(atPath: self.worldDirectoryURL.path) {
            try! self.fileManager.createDirectory(at: self.worldDirectoryURL, withIntermediateDirectories: false)
        }
    }

    private func createTileDataFileIfNotExist() {
        if !self.fileManager.fileExists(atPath: self.tileMapDataFileURL.path) {
            self.fileManager.createFile(atPath: self.tileMapDataFileURL.path, contents: Data(count: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize))
        }
    }

    private func removeWorldDirectoryIfExist() {
        if self.fileManager.fileExists(atPath: self.worldDirectoryURL.path) {
            try! self.fileManager.removeItem(at: self.worldDirectoryURL)
        }
    }

    // MARK: - reset
    func resetWorld() {
        removeWorldDirectoryIfExist()
        createWorldDataIfNotExist()
    }

    // MARK: - load
    func loadTileMapData() -> Data {
        createWorldDataIfNotExist()

        let fileHandle = try! FileHandle(forReadingFrom: self.tileMapDataFileURL)
        let tileMapData = try! fileHandle.readToEnd()
        fileHandle.closeFile()

        return tileMapData!
    }

    // MARK: - save
    func saveTileData(index: Int, tileData: Data) {
        let fileHandle = try! FileHandle(forWritingTo: self.tileMapDataFileURL)
        try! fileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        try! fileHandle.write(contentsOf: tileData)
        fileHandle.closeFile()
    }

}

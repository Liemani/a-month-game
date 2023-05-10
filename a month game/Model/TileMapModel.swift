//
//  MapModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/07.
//

import Foundation
import CoreData

class TileMapModel {

    var tileMapData: Data!
    var tileMap: UnsafeMutableBufferPointer<Int>!

    // MARK: init
    init() {
        load()
        customSetTile()
    }

    func load() {
        createTileMapDataFileIfNotExist()
        loadTileMap()
    }

    func createTileMapDataFileIfNotExist() {
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: Constant.tileMapDataFileURL.path) {
            createWorldDirectoryIfNotExist()
            fileManager.createFile(atPath: Constant.tileMapDataFileURL.path, contents: Data(count: MemoryLayout<Int>.size * 100 * 100))
        }
    }

    func createWorldDirectoryIfNotExist() {
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: Constant.worldDirectoryURL.path) {
            try! fileManager.createDirectory(at: Constant.worldDirectoryURL, withIntermediateDirectories: false)
        }
    }

    func loadTileMap() {
        let fileHandle = try! FileHandle(forReadingFrom: Constant.tileMapDataFileURL)

        tileMapData = fileHandle.readData(ofLength: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize)

        fileHandle.closeFile()

        tileMap = tileMapData.withUnsafeMutableBytes {
            $0.bindMemory(to: Int.self)
        }
    }

    // MARK: set tile
    func setTile(row: Int, column: Int, tileID: Int) {
        self.tileMap[100 * row + column] = tileID
        saveTile(row: row, column: column, tileID: tileID)
    }

    func saveTile(row: Int, column: Int, tileID: Int) {
        var value = tileID
        let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        
        let fileHandle = try! FileHandle(forWritingTo: Constant.tileMapDataFileURL)
        try! fileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * (Constant.gridSize * row + column)))
        fileHandle.write(data)
        try! fileHandle.write(contentsOf: data)
        fileHandle.closeFile()
    }

    // MARK: custom
    func customSetTile() {
        setTile(row: 48, column: 48, tileID: 2)
        setTile(row: 52, column: 52, tileID: 2)
        setTile(row: 52, column: 53, tileID: 2)
    }

}

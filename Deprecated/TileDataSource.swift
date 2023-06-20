//
//  TileFileController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/11.
//

//import Foundation
//
//final class TileDataSource {
//
//    private let fileManager: FileManager
//
//    private var filePath: String!
//    private var updateFileHandle: FileHandle!
//
//    init(worldDirectoryURL: URL) {
//        self.fileManager = FileManager.default
//
//        // TODO: URL.path is deprecated
//        self.filePath = worldDirectoryURL.appending(path: Constant.Name.tileMapFile).path
//
//        self.createFileIfNotExist()
//
//        self.updateFileHandle = FileHandle(forUpdatingAtPath: filePath)
//    }
//
//    func readTileMap() -> Data {
//        try! self.updateFileHandle.seek(toOffset: 0)
//        let tileMapData = try! self.updateFileHandle.readToEnd()!
//        return tileMapData
//    }
//
//    func read(at index: Int) -> Data {
//        try! self.updateFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
//        let tileData = try! self.updateFileHandle.read(upToCount: MemoryLayout<Int>.size)!
//        return tileData
//    }
//
//    func update(tileData: Data, to index: Int) {
//        try! self.updateFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
//        try! self.updateFileHandle.write(contentsOf: tileData)
//    }
//
//}
//
//// MARK: - private
//extension TileDataSource {
//
//    private func createFileIfNotExist() {
//        guard !self.fileManager.fileExists(atPath: self.filePath) else {
//            return
//        }
//
//        let tileMapData = Data(count: MemoryLayout<Int>.size * Constant.gridSize * Constant.gridSize)
//        self.fileManager.createFile(atPath: self.filePath, contents: tileMapData)
//    }
//
//}

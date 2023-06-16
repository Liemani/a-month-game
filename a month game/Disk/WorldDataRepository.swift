//
//  WorldDataRepository.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

class WorldDataRepository {

    private let fileManager: FileManager

    private var filePath: String!
    private var updateFileHandle: FileHandle!

    init(worldDirectoryURL: URL) {
        self.fileManager = FileManager.default

        // TODO: URL.path is deprecated
        self.filePath = worldDirectoryURL.appending(path: Constant.worldDataFileName).path

        self.createFileIfNotExist()

        self.updateFileHandle = FileHandle(forUpdatingAtPath: filePath)
    }

    func read(at index: Int) -> Data {
        try! self.updateFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        let nextIDData = try! self.updateFileHandle.read(upToCount: MemoryLayout<Int>.size)!
        return nextIDData
    }

    func update(data: Data, to index: Int) {
        try! self.updateFileHandle.seek(toOffset: UInt64(MemoryLayout<Int>.size * index))
        try! self.updateFileHandle.write(contentsOf: data)
    }

}

// MARK: - private
extension WorldDataRepository {

    private func createFileIfNotExist() {
        guard !self.fileManager.fileExists(atPath: self.filePath) else {
            return
        }

        let worldData = self.generateInitialWorldData()
        self.fileManager.createFile(atPath: self.filePath, contents: worldData)
    }

    private func generateInitialWorldData() -> Data {
        var nextID = Constant.initialNextID
        return Data(bytes: &nextID,
                             count: MemoryLayout.size(ofValue: nextID))
    }

}

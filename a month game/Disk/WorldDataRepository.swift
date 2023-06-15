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

        self.createIfNotExist()

        self.updateFileHandle = FileHandle(forUpdatingAtPath: filePath)
    }

    func read(index: UInt64) -> Data {
        try! self.updateFileHandle.seek(toOffset: 0)
        let nextIDData = try! self.updateFileHandle.read(upToCount: MemoryLayout<Int>.size)!
        return nextIDData
    }

    func update(data: Data, index: UInt64) {
        try! self.updateFileHandle.seek(toOffset: index)
        try! self.updateFileHandle.write(contentsOf: data)
    }

    // MARK: - private
    private func createIfNotExist() {
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

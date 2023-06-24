//
//  WorldDirectoryController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

class WorldDirectoryUtility {

    static let `default` = WorldDirectoryUtility()

    let fileManager: FileManager

    init() {
        self.fileManager = FileManager.default
    }

    static func directoryURL(worldName name: String) -> URL {
        return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: name)
    }

    func isExist(worldName: String) -> Bool {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)
        return self.fileManager.fileExists(atPath: worldDirectoryURL.path)
    }

    /// - Returns: true if create or false
    func createIfNotExist(worldName: String) {
        guard !self.isExist(worldName: worldName) else {
            return
        }

        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        try! self.fileManager.createDirectory(at: worldDirectoryURL, withIntermediateDirectories: true)
    }

    func remove(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        if self.fileManager.fileExists(atPath: worldDirectoryURL.path) {
            try! self.fileManager.removeItem(at: worldDirectoryURL)
        }
    }

}

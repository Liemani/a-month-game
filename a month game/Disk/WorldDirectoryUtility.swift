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

    /// - Returns: true if create or false
    func createIfNotExist(worldName: String) -> Bool {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)
        if !self.fileManager.fileExists(atPath: worldDirectoryURL.path) {
            try! self.fileManager.createDirectory(at: worldDirectoryURL, withIntermediateDirectories: true)
            return true
        }
        return false
    }

    func remove(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)

        if self.fileManager.fileExists(atPath: worldDirectoryURL.path) {
            try! self.fileManager.removeItem(at: worldDirectoryURL)
        }
    }

}

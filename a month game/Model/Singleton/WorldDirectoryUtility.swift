//
//  WorldDirectoryController.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

/// file structure
/// application support
///     character
///     world
///         world1
///         world2
class FileUtility {

    static let `default` = FileUtility()

    let fileManager: FileManager

    init() {
        self.fileManager = FileManager.default
    }

    var characterDirURL: URL {
        let characterDirURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: "character")
        return characterDirURL
    }

    func worldDirURL(of name: String) -> URL {
        let worldDirURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: "world")
        let currentWorldDirURL = worldDirURL.appending(path: name)
        return currentWorldDirURL
    }

    func isWorldDirExist(worldName: String) -> Bool {
        let worldDirURL = self.worldDirURL(of: worldName)

        return self.fileManager.fileExists(atPath: worldDirURL.path)
    }

    func createCharacterDirIfNotExist() {
        let characterDirURL = self.characterDirURL

        guard !self.fileManager.fileExists(atPath: characterDirURL.path) else {
            return
        }

        try! self.fileManager.createDirectory(at: characterDirURL,
                                              withIntermediateDirectories: false)
    }

    func createWorldDir(worldName: String) {
        let worldDirURL = self.worldDirURL(of: worldName)

        try! self.fileManager.createDirectory(at: worldDirURL,
                                              withIntermediateDirectories: true)
    }

    func remove(worldName: String) {
        let worldDirURL = self.worldDirURL(of: worldName)

        if self.fileManager.fileExists(atPath: worldDirURL.path) {
            try! self.fileManager.removeItem(at: worldDirURL)
        }
    }

}

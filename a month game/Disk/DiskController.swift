//
//  DiskController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/14.
//

import Foundation

/// Handle all disk related function
final class DiskController {

    static private var _default: DiskController?
    static var `default`: DiskController {
        get {
            if let diskController = DiskController._default {
                return diskController
            }
            let diskController = DiskController()
            DiskController._default = diskController
            return diskController
        }
    }

    let fileManager: FileManager

    let coreDataController: CoreDataController
    let tileMapFileController: TileMapFileController
    let userDefaultsController: UserDefaultsController

    // MARK: - init
    init() {
        self.fileManager = FileManager.default

        self.coreDataController = CoreDataController()
        self.tileMapFileController = TileMapFileController()
        self.userDefaultsController = UserDefaultsController()
    }

    // MARK: - set to world
    func setToWorld(ofName name: String) {
        createWorldDirectoryIfNotExist(ofName: name)

        let worldDirectoryURL = self.worldDirectoryURL(ofName: name)

        self.coreDataController.setToWorld(with: worldDirectoryURL)
        self.tileMapFileController.setToWorld(with: worldDirectoryURL)
    }

    private func createWorldDirectoryIfNotExist(ofName name: String) {
        let worldDirectoryURL = self.worldDirectoryURL(ofName: name)

        if !self.fileManager.fileExists(atPath: worldDirectoryURL.path) {
            try! self.fileManager.createDirectory(at: worldDirectoryURL, withIntermediateDirectories: true)
        }
    }

    // MARK: - close files
    func closeFiles() {
        self.closeTileMapFile()
        self.removePersistentStore()
    }

    // MARK: - remove world
    func removeWorldDirectory(ofName name: String) {
        let worldDirectoryURL = self.worldDirectoryURL(ofName: name)

        if self.fileManager.fileExists(atPath: worldDirectoryURL.path) {
            try! self.fileManager.removeItem(at: worldDirectoryURL)
        }
    }

    // MARK: - CoreData
    func loadGameObjectManagedObjectArray() -> [GameObjectManagedObject] {
        return self.coreDataController.loadGameObjectManagedObjectArray()
    }

    func store(gameObject: GameObject) {
        self.coreDataController.store(gameObject: gameObject)
    }

    func delete(gameObject: GameObject) {
        self.coreDataController.delete(gameObject: gameObject)
    }

    func moveCoordinate(of gameObject: GameObject, to newCoordinate: GameObjectCoordinate) {
        self.coreDataController.moveCoordinate(of: gameObject, to: newCoordinate)
    }

    // MARK: - FileManager
    func loadTileData() -> Data {
        return self.tileMapFileController.loadTileMapData()
    }

    func saveTileData(row: Int, column: Int, tileData: Data) {
        self.tileMapFileController.saveTileData(index: Constant.gridSize * row + column, tileData: tileData)
    }

    // MARK: - UserDefaults
    func readUserDefaults(forKey key: String) ->Int {
        return self.userDefaultsController.read(forKey: key)
    }

    func updateUserDefaults(_ value: Int, forKey key: String) {
        self.userDefaultsController.update(value, forKey: key)
    }

    // MARK: - private method
    private func closeTileMapFile() {
        self.tileMapFileController.closeWriteFile()
    }

    private func removePersistentStore() {
        self.coreDataController.removeFirstPersistentStore()
    }

    // MARK: - helper
    // TODO: 99 support same name of worlds
    private func worldDirectoryURL(ofName name: String) -> URL {
        return self.fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: name)
    }

}

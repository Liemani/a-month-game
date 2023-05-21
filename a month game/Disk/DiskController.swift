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

    /// Call this methods after all use
    func close() {
        self.coreDataController.removeFirstPersistentStore()
        self.tileMapFileController.close()
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

    func store(_ gameObject: GameObject) {
        self.coreDataController.store(gameObject)
    }

    func delete(_ gameObject: GameObject) {
        self.coreDataController.delete(gameObject)
    }

    func move(_ gameObject: GameObject, to newCoordinate: GameObjectCoordinate) {
        self.coreDataController.move(gameObject, to: newCoordinate)
    }

    // MARK: - FileManager
    func loadTileData() -> Data {
        return self.tileMapFileController.loadTileMapData()
    }

    func save(tileData: Data, toX x: Int, y: Int) {
        let index = Constant.gridSize * x + y
        self.tileMapFileController.save(tileData: tileData, toIndex: index)
    }

    // MARK: - UserDefaults
    func readUserDefaults(forKey key: String) ->Int {
        return self.userDefaultsController.read(forKey: key)
    }

    func updateUserDefaults(_ value: Int, forKey key: String) {
        self.userDefaultsController.update(value, forKey: key)
    }

    // MARK: - helper
    // TODO: support same name of worlds
    private func worldDirectoryURL(ofName name: String) -> URL {
        return self.fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: name)
    }

}

//
//  DiskController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/14.
//

import Foundation

/// Handle all disk related function
final class DiskController {

    static var `default` = DiskController()

    let fileManager: FileManager

    let persistentContainer: PersistentContainer
    let tileMapFileController: TileMapFileController
    let userDefaultsController: UserDefaultsController

    // MARK: - init
    init() {
        self.fileManager = FileManager.default

        self.persistentContainer = PersistentContainer(name: Constant.worldDataModelName)
        self.tileMapFileController = TileMapFileController()
        self.userDefaultsController = UserDefaultsController()
    }

    // MARK: - set to world
    func setToWorld(ofName name: String) {
        createWorldDirectoryIfNotExist(ofName: name)

        let worldDirectoryURL = self.worldDirectoryURL(ofName: name)

        self.persistentContainer.setToWorld(with: worldDirectoryURL)
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
        self.persistentContainer.removeFirstPersistentStore()
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
    func loadGOMOArray() -> [GameObjectMO] {
        return self.persistentContainer.fetchGOMOArray()
    }

    func newGOMO() -> GameObjectMO {
        return self.persistentContainer.newGOMO()
    }

    func delete(_ goMO: GameObjectMO) {
        self.persistentContainer.delete(goMO)
    }

    func contextSave() {
        self.persistentContainer.contextSave()
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
    // TODO: 99 support same name of worlds
    private func worldDirectoryURL(ofName name: String) -> URL {
        return self.fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: name)
    }

}

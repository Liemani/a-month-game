//
//  DiskController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/14.
//

import Foundation

final class DiskController {

    static let `default` = DiskController()

    let fileManager: FileManager

    let persistentContainer: PersistentContainer
    let tileMapFileController: TileMapFileController

    var worldName: String?

    // MARK: - init
    init() {
        self.fileManager = FileManager.default

        self.persistentContainer = PersistentContainer()
        self.tileMapFileController = TileMapFileController()
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

    // MARK: - load and save
    func loadTileData() -> Data {
        return self.tileMapFileController.loadTileMapData()
    }

    func loadGameItemDictionary() -> Dictionary<Int, GameItem> {
        var gameItemDictionary = Dictionary<Int, GameItem>()

        let gameItemDataArray = self.persistentContainer.loadGameItemDataArray()
        for gameItemData in gameItemDataArray {
            let gameItem = GameItem(typeID: Int(gameItemData.typeID))
            gameItemDictionary[gameItem.id] = gameItem
        }

        return gameItemDictionary
    }

    func saveTileData(row: Int, column: Int, tileData: Data) {
        self.tileMapFileController.saveTileData(index: Constant.gridSize * row + column, tileData: tileData)
    }

    func storeGameItem(gameItem: GameItem) {
        self.persistentContainer.saveGameItem(gameItem: gameItem)
    }

    // TODO: write saveModifiedGameItem()
    // TODO: write modifyGameItem()
    // TODO: write removeGameItem()

    // MARK: - private method
    private func closeTileMapFile() {
        self.tileMapFileController.closeWriteFile()
    }

    private func removePersistentStore() {
        self.persistentContainer.removeFirstPersistentStore()
    }

    // MARK: - helper
    // TODO: 99 support same name of worlds
    private func worldDirectoryURL(ofName name: String) -> URL {
        return self.fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appending(path: name)
    }

}

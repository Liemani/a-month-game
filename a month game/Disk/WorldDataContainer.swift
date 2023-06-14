//
//  DataContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/14.
//

import Foundation

final class WorldDataContainer {

    let gameObjectRepository: GameObjectRepository
    let tileMapRepository: TileMapRepository
    let worldDataRepository: WorldDataRepository

    init(worldName: String) {
        let worldDirectoryURL = WorldDirectoryUtility.directoryURL(worldName: worldName)
        let isNewWorld = WorldDirectoryUtility.default.createIfNotExist(worldName: worldName)

        self.gameObjectRepository = GameObjectRepository(worldDirectoryURL: worldDirectoryURL)
        self.tileMapRepository = TileMapRepository(worldDirectoryURL: worldDirectoryURL)
        self.worldDataRepository = WorldDataRepository(worldDirectoryURL: worldDirectoryURL)

        if isNewWorld {
            self.generateGOMOs()
        }
    }

    private func generateGOMOs() {
        self.newGOMO(typeID: 1, containerID: 0, x: Int32(Constant.centerTileIndex - 2), y: Int32(Constant.centerTileIndex - 3))
        self.newGOMO(typeID: 2, containerID: 0, x: Int32(Constant.centerTileIndex - 1), y: Int32(Constant.centerTileIndex - 3))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex - 1), y: Int32(Constant.centerTileIndex - 1))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex - 1), y: Int32(Constant.centerTileIndex))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex - 1), y: Int32(Constant.centerTileIndex + 1))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex), y: Int32(Constant.centerTileIndex + 1))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex + 1), y: Int32(Constant.centerTileIndex + 1))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex + 1), y: Int32(Constant.centerTileIndex))
        self.newGOMO(typeID: 3, containerID: 0, x: Int32(Constant.centerTileIndex + 1), y: Int32(Constant.centerTileIndex - 1))
        self.newGOMO(typeID: 4, containerID: 0, x: Int32(Constant.centerTileIndex), y: Int32(Constant.centerTileIndex - 3))
        self.newGOMO(typeID: 5, containerID: 0, x: Int32(Constant.centerTileIndex + 1), y: Int32(Constant.centerTileIndex - 3))

        self.contextSave()
    }



    // MARK: - CoreData
    func newGOMO() -> GameObjectMO {
        return self.gameObjectRepository.newGOMO()
    }

    func loadGOMOs() -> [GameObjectMO] {
        return self.gameObjectRepository.fetchGOMOs()
    }

    func contextSave() {
        self.gameObjectRepository.contextSave()
    }

    func delete(_ goMO: GameObjectMO) {
        self.gameObjectRepository.delete(goMO)
    }

    // MARK: - FileManager
    func loadTileData() -> Data {
        return self.tileMapRepository.loadTileMapData()
    }

    func save(tileData: Data, toX x: Int, y: Int) {
        let index = Constant.gridSize * x + y
        self.tileMapRepository.save(tileData: tileData, toIndex: index)
    }

    // MARK: - UserDefaults
    func readNextID() -> Int {
        let nextIDData = self.worldDataRepository.read(index: 0)
        return nextIDData.withUnsafeBytes { $0.load(as: Int.self) }
    }

    func updateNextID(nextID: Int) {
        var nextID = nextID
        let data = Data(bytes: &nextID, count: MemoryLayout<Int>.size)
        self.worldDataRepository.update(data: data, index: 0)
    }

    // MARK: - private
    private func newGOMO(typeID: Int32, containerID: Int32, x: Int32, y: Int32) {
        let managedObject = self.newGOMO()

        managedObject.typeID = typeID
        managedObject.id = Int32(self.readNextID())
        managedObject.containerID = containerID
        managedObject.x = x
        managedObject.y = y
    }

}

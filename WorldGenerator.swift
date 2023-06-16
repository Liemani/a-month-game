//
//  WorldGenerator.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/15.
//

import Foundation

final class WorldGenerator {

    private let worldDataContainer: WorldDataContainer
    private let idGenerator: IDGenerator

    static func generate(worldDataContainer: WorldDataContainer) {
        let worldGenerator = WorldGenerator(worldDataContainer: worldDataContainer)
        worldGenerator.generateGOMOs()
        worldGenerator.generateTileMapData()
    }

    private init(worldDataContainer: WorldDataContainer) {
        self.worldDataContainer = worldDataContainer
        self.idGenerator = IDGenerator(worldDataRepository: worldDataContainer.worldDataRepository)
    }

    private func generateGOMOs() {
        self.newGOMO(type: .pineCone, container: .field, x: Constant.centerTileIndex - 2, y: Constant.centerTileIndex - 3)
        self.newGOMO(type: .pineTree, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 3)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex - 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex - 1, y: Constant.centerTileIndex + 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex, y: Constant.centerTileIndex + 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex + 1)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex)
        self.newGOMO(type: .woodWall, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 1)
        self.newGOMO(type: .branch, container: .field, x: Constant.centerTileIndex, y: Constant.centerTileIndex - 3)
        self.newGOMO(type: .stone, container: .field, x: Constant.centerTileIndex + 1, y: Constant.centerTileIndex - 3)

        self.worldDataContainer.contextSave()
    }

    private func generateTileMapData() {
        self.worldDataContainer.tileService.update(tileType: .woodFloor, toX: Constant.centerTileIndex, y: Constant.centerTileIndex)
    }

    private func newGOMO(type: GameObjectType, container: ContainerType, x: Int, y: Int) {
        self.worldDataContainer.gameObjectService.newGOMO(id: self.idGenerator.generate(), type: type, container: container, x: x, y: y)
    }

}

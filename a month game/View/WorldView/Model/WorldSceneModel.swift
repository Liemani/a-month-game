//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation

class WorldSceneModel {

    private let goRepository: GameObjectRepository
    private var idGenerator: IDGenerator

    var chunkContainer: ChunkContainer
//    var goModels: [Int: [Int: GameObject]]

    private var character: Character!
    private var tileMap: TileMap!

    init(worldRepositoryContainer: WorldRepositoryContainer) {
        self.goRepository = worldRepositoryContainer.goRepository
        self.idGenerator = IDGenerator(worldDataRepository: worldRepositoryContainer.worldDataRepository)

        let chunkContainer = ChunkContainer(chunkRepository: worldRepositoryContainer.chunkRepository, goRepository: goRepository)
        self.chunkContainer = chunkContainer

        self.character = Character(worldDataRepository: worldRepositoryContainer.worldDataRepository)
        self.tileMap = TileMap(tileRepository: worldRepositoryContainer.tileRepository)
    }

    // MARK: - edit
    // MARK: character
    var characterCoord: Coordinate<Int> { self.character.coord }
    var characterPosition: CGPoint { self.character.position }

    func set(coord: Coordinate<Int>) {
        self.character.set(coord: coord)
    }

    // MARK: tile map
    var tileMapBufferPointer: UnsafeBufferPointer<Int> {
        self.tileMap.tilesMapDataPointer
    }

    // MARK: chunk
    var fieldGOs: [GameObject] { self.chunkContainer.fieldGOs }
    func setUp(coord: Coordinate<Int>) {
        self.chunkContainer.setUp(coord: coord)
    }

    func update(coord: Coordinate<Int>, direction: Direction4) {
        self.chunkContainer.update(coord: coord, direction: direction)
    }

    // MARK: game object
    func new(type: GameObjectType, coord: Coordinate<Int>) -> GameObject {
        let id = self.idGenerator.generate()
        let go = GameObject(goRepository: self.goRepository, id: id, type: type, coord: coord)
        self.chunkContainer.update(go, to: go.coord!)
        return go
    }

    #warning("Implement new with invCoord")

    func move(_ go: GameObject, to coord: Coordinate<Int>) {
        self.chunkContainer.update(go, to: coord)
        go.setCoord(coord: coord)
    }

    #warning("Implement move with invCoord")

    func remove(_ go: GameObject) {
        if let goCoord = go.coord {
            self.chunkContainer.remove(go, from: goCoord)
        }

        #warning("Implement remove when go is in the inventory")

        go.delete()
    }

    // MARK: Inventory
    #warning("implement inventory edit methods")

    // MARK: - update
    func update() {
        self.goRepository.update()
    }

}

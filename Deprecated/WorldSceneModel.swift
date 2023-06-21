//
//  GameObjectModel.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

//import Foundation
//
//class WorldSceneModel {
//
//    private var idGenerator: IDGenerator
//
//    var chunkContainer: ChunkContainer
////    var goModels: [Int: [Int: GameObject]]
//
//    private var character: Character!
//
//    init(worldServiceContainer: WorldServiceContainer) {
//        self.idGenerator = IDGenerator()
//
//        let chunkContainer = ChunkContainer(worldServiceContainer: worldServiceContainer)
//        self.chunkContainer = chunkContainer
//
//        self.character = Character(worldDataRepository: worldServiceContainer.worldDataRepository)
//    }
//
//    // MARK: - edit
//    // MARK: character
//    var characterCoord: Coordinate<Int> { self.character.coord }
//    var characterPosition: CGPoint { self.character.position }
//
//    func set(coord: Coordinate<Int>) {
//        self.character.set(coord: coord)
//    }
//
//    // MARK: chunk
//    var fieldGOs: some IteratorProtocol<GameObject> { self.chunkContainer.fieldGOs }
//    func setUp(chunkCoord: ChunkCoordinate) {
//        self.chunkContainer.setUp(chunkCoord: chunkCoord)
//    }
//
//    func update(chunkCoord: ChunkCoordinate, direction: Direction4) {
//        self.chunkContainer.update(chunkCoord: chunkCoord, direction: direction)
//    }
//
//    // MARK: game object
//    func new(type: GameObjectType, chunkCoord: ChunkCoordinate) -> GameObject {
//        let id = self.idGenerator.generate()
//        let go = GameObject(id: id, type: type)
//        self.chunkContainer.update(go, from: nil, to: chunkCoord)
//        return go
//    }
//
//    func new(type: GameObjectType, invCoord: InventoryCoordinate) -> GameObject {
//        let id = self.idGenerator.generate()
//        let go = GameObject(id: id, type: type)
//        print("update go to inventory")
//        return go
//    }
//
//    func move(_ go: GameObject, to chunkCoord: ChunkCoordinate) {
//        if let goInvCoord = go.invCoord {
//            print("remove go from inventory")
//        }
//        self.chunkContainer.update(go, from: go.chunkCoord, to: chunkCoord)
//
//    }
//
//    func move(_ go: GameObject, to invCoord: InventoryCoordinate) {
//        if let goChunkCoord = go.chunkCoord {
//            self.chunkContainer.remove(go, from: goChunkCoord)
//        }
//        print("update go to inventory")
//    }
//
//    func remove(_ go: GameObject) {
//        if let chunkCoord = go.chunkCoord {
//            self.chunkContainer.remove(go, from: chunkCoord)
//        }
//
//        if let invCoord = go.invCoord {
//            print("remove go from inventory")
//        }
//
//        go.delete()
//    }
//
//}

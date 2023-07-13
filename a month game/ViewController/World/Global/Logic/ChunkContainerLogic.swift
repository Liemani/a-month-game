//
//  ChunkContainerLogic.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/07.
//

import Foundation
import SpriteKit

class ChunkContainerLogic {

    private let chunkContainer: ChunkContainer

    init(chunkContainer: ChunkContainer) {
        self.chunkContainer = chunkContainer
    }

    func coordAtLocation(of touch: UITouch) -> ChunkCoordinate? {
        return self.chunkContainer.coordAtLocation(of: touch)
    }
    
    func chunkContainerUpdate(direction: Direction4) {
        chunkContainer.update(direction: direction)
    }

    func item(at chunkCoord: ChunkCoordinate) -> GameObject? {
        return self.chunkContainer.items(at: chunkCoord)?.first
    }

    func items(at chunkCoord: ChunkCoordinate) -> [GameObject]? {
        self.chunkContainer.items(at: chunkCoord)
    }

    func add(_ go: GameObject) {
        let characterCoord = Logics.default.character.chunkCoord.coord

        self.chunkContainer.add(go)

        if !go.type.isWalkable
            && go.chunkCoord!.coord.isAdjacent(to: characterCoord) {
            Logics.default.accessibleGOTracker.add(go)
        }
    }

}

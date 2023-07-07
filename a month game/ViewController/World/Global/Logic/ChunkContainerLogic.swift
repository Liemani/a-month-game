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

}

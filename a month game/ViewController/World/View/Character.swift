//
//  Character.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class Character: SKShapeNode {

    var data: CharacterData

    var streetChunkCoord: ChunkCoordinate
    func moveChunk(direction: Direction4) {
        let directionCoordOfAChunk = direction.coordOfAChunk
        self.position -= directionCoordOfAChunk.cgPoint * Constant.tileWidth
        self.streetChunkCoord += directionCoordOfAChunk
    }

    /// character position is always in the midle chunk
    var lastPosition: CGPoint!
    private var _position: CGPoint!
    override var position: CGPoint {
        get { self._position }
        set { self._position = newValue }
    }

    var velocityVector: CGVector

    // MARK: - init
    override init() {
        self.data = CharacterData()
        self.streetChunkCoord = self.data.chunkCoord
        self.streetChunkCoord.chunk.building.rawCoord = Coordinate()
        self.velocityVector = CGVector()

        super.init()

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: Constant.characterRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        self.path = path
        self.fillColor = .white
        self.strokeColor = .brown
        self.lineWidth = 5.0
        self.zPosition = Constant.ZPosition.character

        let position = TileCoordinate(self.data.buildingCoord).fieldPoint
        self.lastPosition = position
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

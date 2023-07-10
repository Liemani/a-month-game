//
//  Character.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class Character: SKShapeNode {

    let data: CharacterData

    var chunkCoord: ChunkCoordinate { self.data.chunkCoord }

    var chunkChunkCoord: ChunkCoordinate
    func moveChunk(direction: Direction4) {
        let directionCoordOfAChunk = direction.coordOfAChunk
        self.position -= directionCoordOfAChunk.cgPoint * Constant.tileWidth
        self.chunkChunkCoord += directionCoordOfAChunk
    }

    var tileCoord: Coordinate<Int> { self.data.chunkCoord.address.tile.coord }

    /// character position is always in the midle chunk
    var lastPosition: CGPoint!
    private var _position: CGPoint!
    override var position: CGPoint {
        get { self._position }
        set { self._position = newValue }
    }

    var velocityVector: CGVector

    var speedModifier: Double

    private var accessibleRange: Int { Constant.characterAccessibleRange }
    var accessibleFrame: CGRect {
        let side = Constant.tileWidth * Double(self.accessibleRange * 2 + 1)
        let originTileCoord = FieldCoordinate(self.tileCoord - 1)
        let origin = originTileCoord.fieldPoint - Constant.tileWidth / 2

        return CGRect(origin: origin, size: CGSize(width: side, height: side))
    }

    // MARK: - init
    override init() {
        self.data = CharacterData()
        self.chunkChunkCoord = self.data.chunkCoord
        self.chunkChunkCoord.address.tile.rawCoord = Coordinate()
        self.velocityVector = CGVector()
        self.speedModifier = 1.0

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

        let position = FieldCoordinate(self.tileCoord).fieldPoint
        self.lastPosition = position
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Character: TouchResponder {

    func touchBegan(_ touch: UITouch) {
    }

    func touchMoved(_ touch: UITouch) {
    }

    func touchEnded(_ touch: UITouch) {
    }

    func touchCancelled(_ touch: UITouch) {
    }

    func longTouched(_ touch: UITouch) {
        Particle.flutter(result: .rare)
    }

}

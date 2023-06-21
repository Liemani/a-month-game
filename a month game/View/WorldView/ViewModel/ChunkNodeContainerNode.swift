//
//  ChunkNodeContainer.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/21.
//

import Foundation

class ChunkNodeContainerNode: LMINode {

    // MARK: - stored property
    var midChunkCoord: ChunkCoordinate
    private var chunkNodes: [ChunkNode]

    // MARK: - computed property
    var goNodes: some Sequence<GameObjectNode> {
        let sequences = self.chunkNodes.map { $0.goNodes }
        return CombineSequences(sequences: sequences)
    }

    // MARK: - init
    override init() {
        self.midChunkCoord = ChunkCoordinate()
        self.chunkNodes = []

        super.init()

        self.chunkNodes.reserveCapacity(9)
        for _ in 0..<9 {
            let chunkNode = ChunkNode()
            self.chunkNodes.append(chunkNode)
            self.addChild(chunkNode)
        }

        self.zPosition = Constant.ZPosition.gameObjectLayer
    }

    func updateChunkNodesPosition() {
        for direction in Direction9.allCases {
            let directionCoord = direction.coord
            let chunkNodePosition = (directionCoord << 4).toCGPoint() * Constant.tileSide

            let chunkNode = self.chunkNodes[direction]
            chunkNode.position = chunkNodePosition
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - chunk
    func setUp(chunkCoord: ChunkCoordinate) {
        for direction in Direction9.allCases {
            let targetChunkCoord = chunkCoord + direction.coord << 4
            self.chunkNodes[direction].update(chunkCoord: targetChunkCoord)
        }
        self.midChunkCoord = chunkCoord
    }

    func update(chunkCoord: ChunkCoordinate, direction: Direction4) {
        self.shift(direction: direction.opposite)

        for direction in direction.direction8 {
            let tartgetChunkCoord = chunkCoord + direction.coord << 4
            self.chunkNodes[direction].update(chunkCoord: tartgetChunkCoord)
        }
        self.midChunkCoord = chunkCoord
    }

    // MARK: - game object
    func update(_ goNode: GameObjectNode, from prevChunkCoord: ChunkCoordinate?, to currChunkCoord: ChunkCoordinate) {
        if prevChunkCoord != nil {
            goNode.removeFromParent()
        }

        let currChunkDirection = self.midChunkCoord.chunkDirection(to: currChunkCoord)!
        let currChunkNode = self.chunkNodes[currChunkDirection]
        currChunkNode.addChild(goNode)

        goNode.set(chunkCoord: currChunkCoord)
    }

    func remove(_ goNode: GameObjectNode) {
        goNode.removeFromParent()
    }

    private func shift(direction: Direction4) {
        switch direction {
        case .east:
            let temp1 = self.chunkNodes[2]
            let temp2 = self.chunkNodes[5]
            let temp3 = self.chunkNodes[8]
            self.chunkNodes[2] = self.chunkNodes[1]
            self.chunkNodes[5] = self.chunkNodes[4]
            self.chunkNodes[8] = self.chunkNodes[7]
            self.chunkNodes[1] = self.chunkNodes[0]
            self.chunkNodes[4] = self.chunkNodes[3]
            self.chunkNodes[7] = self.chunkNodes[6]
            self.chunkNodes[0] = temp1
            self.chunkNodes[3] = temp2
            self.chunkNodes[6] = temp3
        case .south:
            let temp1 = self.chunkNodes[0]
            let temp2 = self.chunkNodes[1]
            let temp3 = self.chunkNodes[2]
            self.chunkNodes[0] = self.chunkNodes[3]
            self.chunkNodes[1] = self.chunkNodes[4]
            self.chunkNodes[2] = self.chunkNodes[5]
            self.chunkNodes[3] = self.chunkNodes[6]
            self.chunkNodes[4] = self.chunkNodes[7]
            self.chunkNodes[5] = self.chunkNodes[8]
            self.chunkNodes[6] = temp1
            self.chunkNodes[7] = temp2
            self.chunkNodes[8] = temp3
        case .west:
            let temp1 = self.chunkNodes[0]
            let temp2 = self.chunkNodes[3]
            let temp3 = self.chunkNodes[6]
            self.chunkNodes[0] = self.chunkNodes[1]
            self.chunkNodes[3] = self.chunkNodes[4]
            self.chunkNodes[6] = self.chunkNodes[7]
            self.chunkNodes[1] = self.chunkNodes[2]
            self.chunkNodes[4] = self.chunkNodes[5]
            self.chunkNodes[7] = self.chunkNodes[8]
            self.chunkNodes[2] = temp1
            self.chunkNodes[5] = temp2
            self.chunkNodes[8] = temp3
        case .north:
            let temp1 = self.chunkNodes[6]
            let temp2 = self.chunkNodes[7]
            let temp3 = self.chunkNodes[8]
            self.chunkNodes[6] = self.chunkNodes[3]
            self.chunkNodes[7] = self.chunkNodes[4]
            self.chunkNodes[8] = self.chunkNodes[5]
            self.chunkNodes[3] = self.chunkNodes[0]
            self.chunkNodes[4] = self.chunkNodes[1]
            self.chunkNodes[5] = self.chunkNodes[2]
            self.chunkNodes[0] = temp1
            self.chunkNodes[1] = temp2
            self.chunkNodes[2] = temp3
        }
    }

}

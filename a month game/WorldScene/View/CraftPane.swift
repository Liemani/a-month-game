//
//  CraftPane.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftPane: SKSpriteNode {

    static var cellCount: Int { return Constant.craftPaneCellCount }

    func setUp() {
        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.craftCell)

        let defaultSize = Constant.defaultSize
        let craftPaneSize = Constant.craftPaneSize

        let cellCount = CraftPane.cellCount

        let craftCellFirstPosition = CGPoint(x: defaultSize / 2.0, y: craftPaneSize.height - defaultSize / 2.0)
        let craftCellLastPosition = CGPoint() + defaultSize / 2.0

        let craftCellPositionGap: CGFloat = (craftCellFirstPosition.y - craftCellLastPosition.y) / CGFloat(cellCount - 1)

        for index in 0..<cellCount {
            let cell = SKSpriteNode(texture: cellTexture)

            let x = craftCellFirstPosition.x
            let y = craftCellFirstPosition.y - craftCellPositionGap * CGFloat(index)

            cell.position = CGPoint(x: x, y: y)
            cell.zPosition = Constant.ZPosition.craftCell
            cell.size = Constant.defaultNodeSize

            self.addChild(cell)
        }
    }

}

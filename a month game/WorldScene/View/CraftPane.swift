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
            cell.alpha = 0.2

            self.addChild(cell)

            let craftObject = CraftObject()
            craftObject.size = Constant.defaultNodeSize
            craftObject.zPosition = Constant.ZPosition.craftObject
            cell.addChild(craftObject)
        }
    }

    // MARK: update
    func update(with accessableGOs: [GameObject]) {
        let recipes: [GameObjectType: [(type: GameObjectType, count: Int)]] = Constant.recipes

        self.reset()

        var craftObjectIndex = 0
        for (resultGOType, recipe) in recipes {
            guard self.hasIngredient(gameObjects: accessableGOs, forRecipe: recipe) else {
                continue
            }

            self.set(index: craftObjectIndex, type: resultGOType)

            if craftObjectIndex == CraftPane.cellCount - 1 {
                return
            }
            craftObjectIndex += 1
        }
    }

    private func reset() {
        for cell in self.children {
            let craftObject = cell.children[0] as! SKSpriteNode
            
            craftObject.texture = GameObjectType.none.texture
            cell.alpha = 0.2
        }
    }

    private func hasIngredient(gameObjects gos: [GameObject], forRecipe recipe: [(type: GameObjectType, count: Int)]) -> Bool {
        var recipe = recipe

        for go in gos {
            let goType = go.type
            for index in 0..<recipe.count {
                if goType == recipe[index].type {
                    recipe[index].count -= 1
                }
            }
        }

        for (_, count) in recipe {
            if count > 0 {
                return false
            }
        }

        return true
    }

    func set(index craftObjectIndex: Int, type goType: GameObjectType) {
        let cell = self.children[craftObjectIndex]
        let craftObject = cell.children[0] as! CraftObject
        craftObject.set(goType)
        cell.alpha = 1.0
    }

    func craftObject(at touch: UITouch) -> CraftObject? {
        let touchPoint = touch.location(in: self)

        for cell in self.children {
            if cell.contains(touchPoint), self.isCellActivated(cell) {
                let craftObject = cell.children[0] as! CraftObject
                craftObject.activate()
                return craftObject
            }
        }

        return nil
    }

    func isCellActivated(_ cell: SKNode) -> Bool {
        return cell.alpha == 1.0
    }

}

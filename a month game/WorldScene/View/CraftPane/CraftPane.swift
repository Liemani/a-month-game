//
//  CraftPane.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftPane: SKSpriteNode {

    var worldScene: WorldScene { self.scene as! WorldScene }
    var interactionZone: InteractionZone { self.worldScene.interactionZone }

    var cellCount: Int { Constant.craftPaneCellCount }

    func setUp() {
        self.anchorPoint = CGPoint()

        self.position = Constant.craftPanePosition
        self.size = Constant.craftPaneSize

        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.craftCell)

        let defaultSize = Constant.defaultSize
        let craftPaneSize = Constant.craftPaneSize

        let cellCount = self.cellCount

        let craftCellFirstPosition = CGPoint(x: defaultSize / 2.0, y: craftPaneSize.height - defaultSize / 2.0)
        let craftCellLastPosition = CGPoint() + defaultSize / 2.0
        let craftCellPositionGap: CGFloat = (craftCellFirstPosition.y - craftCellLastPosition.y) / CGFloat(cellCount - 1)

        let x = craftCellFirstPosition.x
        var y = craftCellFirstPosition.y

        for _ in 0..<cellCount {
            let cell = CraftCell(texture: cellTexture)

            cell.position = CGPoint(x: x, y: y)
            cell.setUp()

            self.addChild(cell)

             y -= craftCellPositionGap
        }
    }

    // MARK: - update
    func update() {
        let sequences = [
            AnySequence<GameObject>(self.interactionZone.gos),
            AnySequence<GameObject>(self.worldScene.goMOGO.inventory.goKeys)
        ]
        let gos = SequencesIterator(sequences: sequences)

        let recipes: [GameObjectType: [(type: GameObjectType, count: Int)]] = Constant.recipes

        self.reset()

        var craftObjectIndex = 0
        for (resultGOType, recipe) in recipes {
            guard self.hasIngredient(gameObjects: gos, forRecipe: recipe) else {
                continue
            }

            self.set(index: craftObjectIndex, type: resultGOType)

            if craftObjectIndex == self.cellCount - 1 {
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

    private func hasIngredient(gameObjects gos: SequencesIterator<GameObject>, forRecipe recipe: [(type: GameObjectType, count: Int)]) -> Bool {
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

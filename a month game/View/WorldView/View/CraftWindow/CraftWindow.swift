//
//  CraftWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftWindow: LMISpriteNode {

    var cellCount: Int { Constant.craftWindowCellCount }

    private var shouldUpdate: Bool = true

    func setUp() {
        self.anchorPoint = CGPoint()

        self.position = Constant.craftWindowPosition
        self.size = Constant.craftWindowSize

        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.craftCell)

        let defaultSize = Constant.defaultSize
        let craftWindowSize = Constant.craftWindowSize

        let cellCount = self.cellCount

        let craftCellFirstPosition = CGPoint(x: defaultSize / 2.0, y: craftWindowSize.height - defaultSize / 2.0)
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
    func reserveUpdate() { self.shouldUpdate = true }

    func update() {
        guard self.shouldUpdate else { return }

        let sequences: [any Sequence<GameObjectNode>] = [
            self.interactionZone.gos,
            self.worldScene.characterInv,
        ]
        let gos = CombineSequence(sequences: sequences)

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

        self.shouldUpdate = false
    }

    private func reset() {
        for cell in self.children {
            let go = cell.children[0] as! GameObjectNode

            go.setType(.none)
            go.isUserInteractionEnabled = false
            cell.alpha = 0.2
        }
    }

    private func hasIngredient(gameObjects gos: any Sequence<GameObjectNode>, forRecipe recipe: [(type: GameObjectType, count: Int)]) -> Bool {
        var recipe = recipe

        for go in gos {
            let go = go as! GameObjectNode
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

    func set(index gameObjectIndex: Int, type goType: GameObjectType) {
        let cell = self.children[gameObjectIndex]
        let go = cell.children[0] as! GameObjectNode
        go.setType(goType)
        go.isUserInteractionEnabled = true
        cell.alpha = 1.0
    }

//    func refill(_ go: GameObjectNode) {
//        let cell = go.parent as! CraftCell
//        cell.addNoneGO()
//        let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
//        self.worldScene.addGOMO(from: go, to: goCoord)
//        self.consumeIngredient(of: go.type)
//    }

    func consumeIngredient(of goType: GameObjectType) {
        let recipes = Constant.recipes
        let recipe = recipes[goType]!
        let gosToRemove = MaterialInRecipeSequence(recipe: recipe, materials: self.resources())
        self.worldScene.remove(from: gosToRemove)
    }

    private func resources() -> some Sequence<GameObjectNode> {
        let resourceSequences: [any Sequence<GameObjectNode>] = [
            self.interactionZone.gos,
            self.worldScene.characterInv,
        ]
        return CombineSequence(sequences: resourceSequences)
    }

    func isCellActivated(_ cell: SKNode) -> Bool {
        return cell.alpha == 1.0
    }

}

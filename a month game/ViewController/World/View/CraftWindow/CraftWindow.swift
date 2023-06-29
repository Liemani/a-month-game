//
//  CraftWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftWindow: SKNode {

    var cellCount: Int { Constant.craftWindowCellCount }

    override init() {
        super.init()

        self.position = Constant.craftWindowPosition

        let cellTexture = SKTexture(imageNamed: Constant.ResourceName.craftCell)

        let cellWidth = Constant.defaultWidth
        let cellSpacing = Constant.invCellSpacing

        let distanceOfCellsCenter = cellWidth + cellSpacing
        let endCellOffset = distanceOfCellsCenter * Double((self.cellCount - 1) / 2)

        var positionY = -endCellOffset

        for _ in 0..<self.cellCount {
            let cell = CraftCell(texture: cellTexture)

            cell.setUp()
            cell.position = CGPoint(x: 0, y: positionY)

            self.addChild(cell)

            positionY += distanceOfCellsCenter
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - update
    func update() {
//        let sequences: [any Sequence<GameObjectNode>] = [
//            self.interactionZone.gos,
//            self.worldScene.characterInv,
//        ]
//        let gos = CombineSequence(sequences: sequences)
        let gos: [GameObject] = []

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
//            let go = cell.children[0] as! GameObject
//
//            print("craft window will not have game object node, it must has craft object")
////            go.type = .none
            cell.alpha = 0.2
        }
    }

    private func hasIngredient(gameObjects gos: any Sequence<GameObject>, forRecipe recipe: [(type: GameObjectType, count: Int)]) -> Bool {
        var recipe = recipe

        for go in gos {
            let go = go as! GameObject
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
        let go = cell.children[0] as! GameObject
            print("craft window will not have game object node, it must has craft object")
//        go.type = goType
        cell.alpha = 1.0
    }

//    func refill(_ go: GameObjectNode) {
//        let cell = go.parent as! CraftCell
//        cell.addNoneGO()
//        let goCoord = GameObjectCoordinate(containerType: .thirdHand, x: 0, y: 0)
//        self.worldScene.addGOMO(from: go, to: goCoord)
//        self.consumeIngredient(of: go.type)
//    }

//    func consumeIngredient(of goType: GameObjectType) {
//        let recipes = Constant.recipes
//        let recipe = recipes[goType]!
//        let gosToRemove = MaterialInRecipeSequence(recipe: recipe, materials: self.resources())
//        self.worldScene.remove(from: gosToRemove)
//    }
//
//    private func resources() -> some Sequence<GameObjectNode> {
//        let resourceSequences: [any Sequence<GameObjectNode>] = [
//            self.interactionZone.gos,
//            self.worldScene.characterInv,
//        ]
//        return CombineSequence(sequences: resourceSequences)
//    }

    func isCellActivated(_ cell: SKNode) -> Bool {
        return cell.alpha == 1.0
    }

}

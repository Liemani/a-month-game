//
//  CraftWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftObject: SKSpriteNode {

    var goType: GameObjectType

    init(goType: GameObjectType) {
        self.goType = goType

        super.init(texture: goType.texture, color: .white, size: Constant.defaultNodeSize)

        self.zPosition = Constant.ZPosition.gameObject
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(goType: GameObjectType) {
        self.goType = goType
        self.texture = goType.texture
    }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

}

class CraftCell: SKSpriteNode {

    var craftObject: CraftObject { self.children.first as! CraftObject }

    init(texture: SKTexture) {
        super.init(texture: texture, color: .white, size: texture.size())

        self.deactivate()
        self.addCraftObject()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCraftObject() {
        let craftObject = CraftObject(goType: GameObjectType.none)
        self.addChild(craftObject)
    }

    func activate() {
        self.alpha = 1.0
    }

    func deactivate() {
        self.alpha = 0.2
    }

}

class CraftWindow: SKNode {

    var cellCount: Int { Constant.craftWindowCellCount }

    var cells: [CraftCell] { self.children as! [CraftCell] }

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

            cell.size = Constant.defaultNodeSize
            cell.position = CGPoint(x: 0, y: positionY)
            cell.zPosition = Constant.ZPosition.craftCell

            self.addChild(cell)

            positionY += distanceOfCellsCenter
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - update
    func update(gos: any Sequence<GameObject>) {
        self.clear()

        let recipes: [GameObjectType: [(type: GameObjectType, count: Int)]] = Constant.recipes
        var craftObjectIndex = 0

        for (resultGOType, recipe) in recipes {
            guard craftObjectIndex < self.cellCount else {
                return
            }

            guard self.hasIngredient(gos: gos, forRecipe: recipe) else {
                continue
            }

            self.set(index: craftObjectIndex, type: resultGOType)

            craftObjectIndex += 1
        }
    }

    func clear() {
        for cell in self.cells {
            let craftObject = cell.craftObject
            craftObject.update(goType: .none)
            cell.deactivate()
        }
    }

    private func hasIngredient(gos: any Sequence<GameObject>, forRecipe recipe: [(type: GameObjectType, count: Int)]) -> Bool {
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

    func set(index: Int, type goType: GameObjectType) {
        let cell = self.cells[index]
        cell.craftObject.update(goType: goType)
        cell.activate()
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

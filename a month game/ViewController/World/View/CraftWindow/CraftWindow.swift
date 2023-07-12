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

    var consumeTargets: [GameObject]

    init() {
        self.goType = .none
        self.consumeTargets = []

        super.init(texture: GameObjectType.none.textures[0],
                   color: .white,
                   size: CGSize())
        self.zPosition = Constant.ZPosition.gameObject
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func activate() {
        self.alpha = 0.5

        for go in self.consumeTargets {
            go.highlight()
        }
    }

    func deactivate() {
        self.alpha = 1.0

        for go in self.consumeTargets {
            go.removeHighlight()
        }
    }

    func update(type goType: GameObjectType, consumeTargets: [GameObject]) {
        self.goType = goType

        self.texture = goType.textures[0]
        self.size = Constant.gameObjectSize

        if goType.layerCount == 2 {
            if self.children.count == 1 {
                let cover = self.children[0] as! SKSpriteNode
                cover.texture = goType.textures[1]
            } else {
                let cover = SKSpriteNode(texture: goType.textures[1])
                cover.size = Constant.coverSize
                cover.zPosition = Constant.ZPosition.gameObjectCover
                self.addChild(cover)
            }
        } else {
            self.removeAllChildren()
        }

        self.consumeTargets = consumeTargets
    }

    func clear() {
        self.goType = .none
        self.removeAllChildren()
        self.texture = self.goType.textures[0]
        self.size = CGSize()
        self.consumeTargets.removeAll()
    }

}

class CraftCell: SKSpriteNode, TouchResponder {

    var craftObject: CraftObject { self.children.first as! CraftObject }

    init(texture: SKTexture) {
        super.init(texture: texture, color: .white, size: texture.size())

        self.deactivate()
        self.addChild(CraftObject())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func activate() {
        self.alpha = 1.0
    }

    private func deactivate() {
        self.alpha = 0.2
    }

    func update(type goType: GameObjectType, consumeTargets: [GameObject]) {
        self.craftObject.update(type: goType, consumeTargets: consumeTargets)
        if goType == .none {
            self.deactivate()
        } else {
            self.activate()
        }
    }

    func clear() {
        self.craftObject.clear()
        self.deactivate()
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
        let cellSpacing = Constant.defaultPadding

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

        let recipes: [GameObjectType: [GameObjectType: Int]] = Constant.recipes
        var craftObjectIndex = 0

        for (resultGOType, recipe) in recipes {
            guard craftObjectIndex < self.cellCount else {
                return
            }

            guard self.hasIngredient(gos: gos, forRecipe: recipe) else {
                continue
            }

            var recipe = recipe
            var consumeTargets: [GameObject] = []

            for go in gos {
                let go = go as! GameObject
                let goType = go.type
                if let typeCount = recipe[goType],
                   typeCount > 0 {
                    recipe[goType] = typeCount - 1
                    consumeTargets.append(go)
                }
            }

            self.update(index: craftObjectIndex,
                        type: resultGOType,
                        consumeTargets: consumeTargets)

            craftObjectIndex += 1
        }
    }

    func update(index: Int, type goType: GameObjectType, consumeTargets: [GameObject]) {
        let cell = self.cells[index]
        cell.update(type: goType, consumeTargets: consumeTargets)
    }

    func clear() {
        for cell in self.cells {
            cell.clear()
        }
    }

    private func hasIngredient(gos: any Sequence<GameObject>, forRecipe recipe: [GameObjectType: Int]) -> Bool {
        var recipe = recipe

        for go in gos {
            let go = go as! GameObject
            let goType = go.type
            if let typeCount = recipe[goType] {
                recipe[goType] = typeCount - 1
            }
        }

        for (_, count) in recipe {
            if count > 0 {
                return false
            }
        }

        return true
    }

    func isCellActivated(_ cell: CraftCell) -> Bool {
        return cell.craftObject.goType != .none
    }

}

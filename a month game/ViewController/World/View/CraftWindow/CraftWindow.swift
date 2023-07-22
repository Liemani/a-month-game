//
//  CraftWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/25.
//

import Foundation
import SpriteKit

class CraftObject: SKNode {

    var type: GameObjectType

    var consumeTargets: [GameObject]

    override init() {
        self.type = .none
        self.consumeTargets = []

        super.init()

        self.addChild(SKSpriteNode())
        self._setTexture()

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
        self.type = goType
        self._setTexture()

        self.consumeTargets = consumeTargets
    }

    private var _textureNode: SKSpriteNode { self.children[0] as! SKSpriteNode }
    private var _cover: SKSpriteNode? {
        return (self.children.count == 2)
            ? self.children[1] as! SKSpriteNode?
            : nil
    }

    private func _setTexture() {
        let type = self.type
        let texture = type.texture

        self._textureNode.texture = texture
        self._textureNode.size = Constant.defaultNodeSize * type.sizeScale

        guard type.hasCover else {
            self._textureNode.position = CGPoint.zero
            self._cover?.removeFromParent()
            return
        }

        self.setCover()
    }

    func setCover() {
        if let cover = self._cover {
            cover.texture = self.type.texture
        } else {
            self._textureNode.position = Constant.Position.gameObjectCoveredBase
            self._addCover()
        }
    }

    func removeCover() {
        self._cover?.removeFromParent()
    }

    private func _addCover() {
        let cover = SKSpriteNode(texture: self.type.texture)
        cover.size = Constant.coverSize
        cover.zPosition = Constant.ZPosition.gameObjectCover
        cover.xScale = -1.0
        self.addChild(cover)
    }

    func clear() {
        self.type = .none
        self._setTexture()
        self.consumeTargets.removeAll()
    }

}

class CraftCell: SKSpriteNode {

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
        return cell.craftObject.type != .none
    }

}

extension CraftCell: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is TapRecognizer.Type:
            return true
        default:
            return false
        }
    }

}

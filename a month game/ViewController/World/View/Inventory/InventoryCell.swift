//
//  InventoryCell.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/22.
//

import Foundation
import SpriteKit

class InventoryCell: SKSpriteNode {

    var qualityBox: SKShapeNode { self.children[0] as! SKShapeNode }
    var go: GameObject? { self.children.last as? GameObject }

    var isEmpty: Bool { self.go == nil }

    // MARK: init
    init(texture: SKTexture?) {
        super.init(texture: texture, color: .white, size: texture?.size() ?? CGSize())

        self.initQualityBox()
        self.hideQualityBox()
    }

    private override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func activate() {
        self.alpha = 0.5
    }

    func deactivate() {
        self.alpha = 1.0
    }

    func hideQualityBox() {
        self.qualityBox.isHidden = true
    }

    /// Suppose go exist
    func unhideQualityBox() {
        self.qualityBox.isHidden = false
        self.setQuality(self.go!.quality)
    }

    var invCoord: InventoryCoordinate {
        let inventory = self.parent as! Inventory
        let index = inventory.coordAtLocation(of: self)!
        return InventoryCoordinate(inventory.id!, index)
    }

    func initQualityBox() {
        let boxSize = Constant.Size.qualityBox

        let qualityBox = SKShapeNode(rectOf: boxSize)
        qualityBox.position = Constant.Position.qualityBox
        qualityBox.zPosition = Constant.ZPosition.gameObjectQualityLabel
        qualityBox.fillColor = .black
        qualityBox.strokeColor = .black
        qualityBox.alpha = 0.5
        self.addChild(qualityBox)

        let qualityLabel = SKLabelNode()
        qualityLabel.fontName = "Helvetica-Bold"
        qualityLabel.fontSize = 12.0
        qualityLabel.position = Constant.Position.qualityLabel
        qualityLabel.zPosition = 10.0
        qualityLabel.horizontalAlignmentMode = .right
        qualityBox.addChild(qualityLabel)
    }

    func setQuality(_ value: Double) {
        let label = self.qualityBox.children[0] as! SKLabelNode

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        let qualityString = formatter.string(from: value as NSNumber)!

        label.text = qualityString
    }

}

extension InventoryCell: InventoryProtocol {

    typealias Coord = Int
    typealias Item = GameObject
    typealias Items = [GameObject]

    func isValid(_ coord: Int) -> Bool {
        return coord == 0
    }

    func items(at coord: Int) -> [GameObject]? {
        guard self.isValid(coord) else { return nil }

        if let go = self.go {
            return [go]
        } else {
            return nil
        }
    }

    func itemsAtLocation(of touch: UITouch) -> [GameObject]? {
        if self.isBeing(touched: touch),
           let go = self.go {
            return [go]
        }

        return nil
    }

    func coordAtLocation(of touch: UITouch) -> Int? {
        if self.isBeing(touched: touch) {
            return 0
        }

        return nil
    }

    func add(_ item: GameObject, to coord: Int) {
        guard self.isValid(coord) else { return }

        self.addChild(item)

        self.unhideQualityBox()
    }

    func remove(_ item: GameObject, from coord: Int) {
        guard self.isValid(coord) else { return }

        self.hideQualityBox()

        item.removeFromParent()
    }

    func makeIterator() -> some IteratorProtocol<GameObject> {
        if let go = self.go {
            return [go].makeIterator()
        } else {
            return [].makeIterator()
        }
    }

}

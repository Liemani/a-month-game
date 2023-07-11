//
//  InfoWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation
import SpriteKit

class InfoWindow: SKShapeNode {

    private var textLabel: SKLabelNode!

    override init() {
        super.init()

        let size = Constant.Size.infoWindow
        let origin = -size.cgPoint / 2.0

        let rect = CGRect(origin: origin, size: size)

        let path = CGPath(roundedRect: rect,
                          cornerWidth: Constant.defaultPadding,
                          cornerHeight: Constant.defaultPadding,
                          transform: nil)

        self.path = path

        self.zPosition = Constant.ZPosition.infoWindow
        self.isHidden = true
        self.strokeColor = .black
        self.fillColor = .white

        self.addContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addContent() {
        let cropNode = SKCropNode()

        let rectSize = Constant.Size.infoWindow - Constant.defaultPadding * 2.0
        let maskNode = SKShapeNode(rectOf: rectSize)
        maskNode.fillColor = .black
        cropNode.maskNode = maskNode

        self.addChild(cropNode)

        let textLabel = SKLabelNode(fontNamed: "Helvetica")
        textLabel.numberOfLines = 0
        textLabel.horizontalAlignmentMode = .left
        textLabel.position = -Constant.Size.infoWindow.cgPoint / 2.0 + Constant.defaultPadding
        textLabel.fontColor = .black
        textLabel.fontSize = 17.0
        textLabel.zPosition = 1.0

        self.textLabel = textLabel

        cropNode.addChild(textLabel)
    }

    func setText(_ text: String) {
        self.textLabel.text = text
    }

    func hide() {
        self.isHidden = true
        // TODO: remove any data
    }

}

//
//  InfoWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation
import SpriteKit

class InfoWindow: SKShapeNode {

    private let content: SKNode
    private let label: SKLabelNode

    var safeAreaSize: CGSize {
        let cropNode = self.children[0] as! SKCropNode
        return cropNode.maskNode!.frame.size
    }

    var contenPositionYMin: Double { self.safeAreaSize.height / 2.0 }
    var contenPositionYMax: Double { self.contenPositionYMin + self.label.frame.height - safeAreaSize.height }

    override init() {
        self.content = SKNode()
        self.label = SKLabelNode()

        super.init()

        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUp() {
        self.setUpSelf()
        self.setUpContent()
        self.setUpCloseButton()
    }

    func setUpSelf() {
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
    }

    func setUpContent() {
        let cropNode = SKCropNode()

        let rectSize = Constant.Size.infoWindow - Constant.defaultPadding * 2.0

        let maskNode = SKShapeNode(rectOf: rectSize)
        maskNode.fillColor = .black
        cropNode.maskNode = maskNode

        self.addChild(cropNode)

        self.setUpLabel()
        cropNode.addChild(self.content)
        self.content.addChild(label)
    }

    func setUpCloseButton() {
        let closeButton = Button(texture: nil,
                                 frame: Constant.Frame.infoWindowCloseButton,
                                 text: "X",
                                 eventType: WorldEventType.infoWindowCloseButton)
        closeButton.color = .gray
        self.addChild(closeButton)
    }

    func setUpLabel() {
        let label = self.label

        label.fontName = "Helvetica"
        label.numberOfLines = 0
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .left
        label.position.x = -self.safeAreaSize.width / 2.0
        label.fontColor = .black
        label.fontSize = 17.0
        label.zPosition = 1.0
    }

    func setText(_ text: String) {
        self.label.text = text

        self.content.position.y = self.contenPositionYMin
    }

    func hide() {
        self.isHidden = true
        self.label.text = nil
    }

}

extension InfoWindow: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is PanRecognizer.Type:
            return true
        default:
            return false
        }
    }

}

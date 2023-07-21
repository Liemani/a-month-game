//
//  Character.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

class Character: SKShapeNode {

    let data: CharacterData

    // MARK: - init
    override init() {
        self.data = CharacterData()

        super.init()

        let path = CGMutablePath()
        path.addArc(center: CGPoint(),
                    radius: Constant.characterRadius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        self.path = path

        self.fillColor = .white
        self.strokeColor = .brown
        self.lineWidth = 5.0
        self.zPosition = Constant.ZPosition.character
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

}

// MARK: touch responder
extension Character: TouchResponder {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool {
        switch type {
        case is TapRecognizer.Type,
            is PanRecognizer.Type,
            is PinchRecognizer.Type,
            is LongTouchRecognizer.Type:
            return true
        default:
            return false
        }
    }

}

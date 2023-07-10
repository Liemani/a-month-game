//
//  InfoWindow.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/10.
//

import Foundation
import SpriteKit

class InfoWindow: SKShapeNode {

    override init() {
        super.init()

        let size = CGSize(width: Constant.defaultWidth * 3.0,
                          height: Constant.defaultWidth * 5.0)
        let origin = -size.cgPoint / 2.0

        let rect = CGRect(origin: origin, size: size)

        let path = CGPath(roundedRect: rect,
                          cornerWidth: Constant.invCellSpacing,
                          cornerHeight: Constant.invCellSpacing,
                          transform: nil)

        self.path = path

        self.zPosition = Constant.ZPosition.infoWindow
        self.isHidden = true
        self.strokeColor = .black
        self.fillColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hide() {
        self.isHidden = true
        // TODO: remove any data
    }

}

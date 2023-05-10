//
//  PortalController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/10.
//

import UIKit

class PortalController {

    var portalScene: PortalScene!

    init() {
        let portalScene = PortalScene()

        portalScene.size = Constant.screenSize
        portalScene.scaleMode = .aspectFit

        self.portalScene = portalScene
    }

}

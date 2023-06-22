//
//  LMITouchable.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

protocol TouchEventHandler {

    var touch: UITouch { get }

    func touchBegan()
    func touchMoved()
    func touchEnded()
    func touchCancelled()

}

//
//  LMITouchable.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/16.
//

import Foundation
import SpriteKit

protocol LMITouchable {

    func touchBegan(_ touch: UITouch)
    func touchMoved(_ touch: UITouch)
    func touchEnded(_ touch: UITouch)
    func touchCancelled(_ touch: UITouch)
    func resetTouch(_ touch: UITouch)

}

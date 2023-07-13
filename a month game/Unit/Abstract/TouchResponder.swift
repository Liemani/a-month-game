//
//  TouchResponder.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/22.
//

import Foundation
import SpriteKit

protocol TouchResponder: SKNode {

    func isRespondable(with type: TouchRecognizer.Type) -> Bool

}

//
//  GestureEventHandlerManager.swift
//  a month game
//
//  Created by 박정훈 on 2023/06/24.
//

import Foundation
import SpriteKit

protocol GestureEventHandler {

    func handle(_ gesture: UIGestureRecognizer)
    
    func began()
    func changed()
    func ended()
    func cancelled()
    func complete()

}

//
//  ContainerNode.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol ContainerNode: SKNode {

    func add(by gameObjectMO: GameObjectMO) -> GameObject?

    func gameObject(at touch: UITouch) -> GameObject?

}

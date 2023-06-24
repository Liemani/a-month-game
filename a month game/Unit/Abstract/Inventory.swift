//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol Inventory: SKNode, Sequence {

    associatedtype Item
    associatedtype Coord

    func isValid(_ coord: Coord) -> Bool
    func contains(_ item: Item) -> Bool

    func item(at coord: Coord) -> Item?
    func itemAtLocation(of touch: UITouch) -> Item?

    // MARK: edit
    func add(_ item: Item)
    func move(_ item: Item)
    func remove(_ item: Item)

}

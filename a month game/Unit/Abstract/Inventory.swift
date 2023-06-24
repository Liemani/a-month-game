//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation
import SpriteKit

protocol Inventory<T, U>: Sequecen {

    func contains(_ go: T) -> Bool
    func isValid(_ coord: U) -> Bool

    func element(at coord: U) -> T?
    func coord(of go: T) -> U?

    // MARK: edit
    func add(_ go: T, to coord: U)
    func move(_ go: T, from coord: U, to coord: U)
    func remove(_ go: T, from coord: U)

}

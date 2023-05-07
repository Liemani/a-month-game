//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import Foundation

struct Constant {
    static let defaultSize: Double = 250

    static let screenSize: CGSize = CGSize(width: 750 * 2, height: 1334 * 2)
    static let screenCenter: CGPoint = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)

    static let menuPosition: CGPoint = CGPoint(x: screenSize.width / 2 - defaultSize, y: screenSize.height / 2 - defaultSize)
    static let defaultNodeSize: CGSize = CGSize(width: defaultSize, height: defaultSize)

    static let inventoryCellCount: Int = 5
    static let inventoryCellFirstPosition: CGPoint = CGPoint(x: -screenCenter.x + defaultSize, y: -screenCenter.y + defaultSize)
    static let inventoryCellLastPosition: CGPoint = CGPoint(x: screenCenter.x - defaultSize, y: -screenCenter.y + defaultSize)

    struct Frame {
        static let character: CGRect = CGRect(origin: CGPoint(), size: CGSize(width: defaultSize, height: defaultSize))
        static let menuButton: CGRect = CGRect(origin: menuPosition, size: CGSize(width: defaultSize, height: defaultSize))
    }

    struct ResourceName {
        static let character: String = "character"
        static let menuButton: String = "menu button"
        static let inventoryCell: String = "inventory cell"
        static let tile: String = "tile"
    }
    static let velocityDamping: Double = 1500.0
}
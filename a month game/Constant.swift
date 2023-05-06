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
    static let menuPosition: CGPoint = CGPoint(x: screenSize.width - defaultSize, y: screenSize.height - defaultSize)
    static let defaultNodeSize: CGSize = CGSize(width: defaultSize, height: defaultSize)

    struct Frame {
        static let character: CGRect = CGRect(origin: screenCenter, size: CGSize(width: defaultSize, height: defaultSize))
        static let menuButton: CGRect = CGRect(origin: CGPoint(x: screenSize.width - defaultSize, y: screenSize.height - defaultSize), size: CGSize(width: defaultSize, height: defaultSize))

        static let inventoryCell: Array<CGRect> = [
            CGRect(origin: CGPoint(x: defaultSize, y: defaultSize), size: CGSize(width: defaultSize, height: defaultSize)),
            CGRect(origin: CGPoint(x: (defaultSize + screenCenter.x) / 2, y: defaultSize), size: CGSize(width: defaultSize, height: defaultSize)),
            CGRect(origin: CGPoint(x: screenCenter.x, y: defaultSize), size: CGSize(width: defaultSize, height: defaultSize)),
            CGRect(origin: CGPoint(x: (screenCenter.x + screenSize.width - defaultSize) / 2, y: defaultSize), size: CGSize(width: defaultSize, height: defaultSize)),
            CGRect(origin: CGPoint(x: screenSize.width - defaultSize, y: defaultSize), size: CGSize(width: defaultSize, height: defaultSize))
        ]

    }

    struct ResourceName {
        static let character: String = "character"
        static let menuButton: String = "menu button"
        static let inventoryCell: String = "inventory cell"
        static let tile: String = "tile"
    }
}

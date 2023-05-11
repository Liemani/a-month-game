//
//  Constant.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/06.
//

import Foundation

struct Constant {

    static let defaultSize = 250.0

    static let screenSize = CGSize(width: 750 * 2, height: 1334 * 2)
    static let screenCenter = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)

    static let defaultNodeSize = CGSize(width: defaultSize, height: defaultSize)
    static let menuPosition = CGPoint(x: screenSize.width / 2 - defaultSize, y: screenSize.height / 2 - defaultSize)
    static let enterButtonPosition = screenCenter
    static let enterButtonSize = CGSize(width: defaultSize * 3, height: defaultSize)
    static let resetButtonPosition = CGPoint(x: screenCenter.x, y: screenCenter.y - defaultSize * 2)
    static let resetButtonSize = CGSize(width: defaultSize * 2, height: defaultSize)

    static let inventoryCellCount = 5
    static let inventoryCellFirstPosition = CGPoint(x: -screenCenter.x + defaultSize, y: -screenCenter.y + defaultSize)
    static let inventoryCellLastPosition = CGPoint(x: screenCenter.x - defaultSize, y: -screenCenter.y + defaultSize)

    static let gridSize: Int = 100

    struct Frame {
        static let character = CGRect(origin: CGPoint(), size: CGSize(width: defaultSize, height: defaultSize))
        static let menuButton = CGRect(origin: menuPosition, size: CGSize(width: defaultSize, height: defaultSize))
        static let enterButton = CGRect(origin: enterButtonPosition, size: enterButtonSize)
        static let resetButton = CGRect(origin: resetButtonPosition, size: resetButtonSize)
    }

    struct ResourceName {
        static let character = "character"
        static let menuButton = "menu button"
        static let inventoryCell = "inventory cell"
        static let bgPortal = "bg_portal"
        static let button = "button"

        static let grassTile = "tile_grass"
        static let woodTile = "tile_wood"
        static let woodWallTile = "tile_wall_wood"
    }
    
    static let velocityDamping = 3000.0

    // MARK: - URL
    static let worldDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("world_a")
    static let tileMapDataFileURL = worldDirectoryURL.appendingPathComponent("tileMapData")

}

//
//  Resource.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/15.
//

import Foundation
import SpriteKit

struct Resource {
    // MARK: - resource name
    struct Name {
        static let character = "character"
        static let menuButton = "menu button"
        static let inventoryCell = "inventory cell"
        static let bgPortal = "bg_portal"
        static let button = "button"

        static let grassTile = "tile_grass"
        static let woodTile = "tile_wood"
        static let woodWallTile = "tile_wall_wood"

        static let gameItemDefault = "game_item_default"
        static let gameItemSeedPineCone = "game_item_seed_pine_cone"
    }

    // MARK: - tile
    static let tileTypeIDToResourceName: [String] = [
        Resource.Name.grassTile,
        Resource.Name.woodTile,
        Resource.Name.woodWallTile,
    ]

    static let tileResourceArray: [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)] = ({
        var array = [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)](repeating: (SKTileGroup(), SKTileDefinition()), count: Resource.tileTypeIDToResourceName.count)

        for tileTypeID in 0..<Resource.tileTypeIDToResourceName.count {
            let tileTexture = SKTexture(imageNamed: Resource.tileTypeIDToResourceName[tileTypeID])
            let tileDefinition = SKTileDefinition(texture: tileTexture)
            let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
            array[tileTypeID] = (tileGroup, tileDefinition)
        }

        return array
    })()

    // MARK: - game item
    static let gameItemTypeIDToInformation: [(gameItemType: GameObject.Type, resourceName: String)] = [
        (GameObject.self, Resource.Name.gameItemDefault),
        (GameObjectSeedPineCone.self, Resource.Name.gameItemSeedPineCone),
    ]

    static let gameItemTextureArray: [SKTexture] = ({
        var array = [SKTexture](repeating: SKTexture(), count: Resource.gameItemTypeIDToInformation.count)

        for gameItemTypeID in 0..<Resource.gameItemTypeIDToInformation.count {
            let resourceName = Resource.gameItemTypeIDToInformation[gameItemTypeID].resourceName
            let gameItemNode = SKTexture(imageNamed: resourceName)
            array[gameItemTypeID] = (gameItemNode)
        }

        return array
    })()
}

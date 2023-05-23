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
        // MARK: ui
        static let character = "character"
        static let menuButton = "menu button"
        static let inventoryCell = "inventory cell"
        static let bgPortal = "bg_portal"
        static let button = "button"
        static let leftHand = "left_hand"
        static let rightHand = "right_hand"

        // MARK: game object
        static let gameObjectDefault = "game_object_default"
        static let gameObjectPineCone = "game_object_pine_cone"
        static let gameObjectPineTree = "game_object_pine_tree"
        static let gameObjectWoodWall = "game_object_wood_wall"
        static let gameObjectStone = "game_object_stone"
        static let gameObjectBranch = "game_object_branch"
        static let gameObjectAxe = "game_object_axe"
    }

    // MARK: - game object
    /// Define GameObject type
    static let gameObjectTypeIDToInformation: [(type: GameObject.Type, resourceName: String)] = [
        (GameObject.self, Resource.Name.gameObjectDefault),
        (GameObjectPineCone.self, Resource.Name.gameObjectPineCone),
        (GameObjectPineTree.self, Resource.Name.gameObjectPineTree),
        (GameObjectWoodWall.self, Resource.Name.gameObjectWoodWall),
        (GameObjectBranch.self, Resource.Name.gameObjectBranch),
        (GameObjectStone.self, Resource.Name.gameObjectStone),
        (GameObjectAxe.self, Resource.Name.gameObjectAxe),
    ]

    static let gameObjectTypeIDToResource: [ObjectIdentifier: (typeID: Int, texture: SKTexture)] = ({
        var dictionary: [ObjectIdentifier: (typeID: Int, texture: SKTexture)] = [:]

        for (index, information) in Resource.gameObjectTypeIDToInformation.enumerated() {
            let key = ObjectIdentifier(information.type)
            let texture = SKTexture(imageNamed: information.resourceName)
            let value = (typeID: index, texture: texture)
            dictionary[key] = value
        }

        return dictionary
    })()

    static func getTexture(of gameObjectType: GameObject.Type) -> SKTexture {
        let objectIdentifier = ObjectIdentifier(gameObjectType)
        return Resource.gameObjectTypeIDToResource[objectIdentifier]!.texture
    }

}

// TODO: move
// tile type constant
extension TileType {

    static let GRASS = TileType(rawValue: 0)!
    static let WOOD = TileType(rawValue: 1)!

}

// MARK: - tile
// TODO: move to new file at constant directory tile type define to Extension.swift in constant directory and gat resource name from constant
class TileType: RawTypeWrapper {

    typealias RawValue = Int

    private struct Resource {
        static let name: [String] = [
            "tile_grass",
            "tile_wood",
        ]

        static let GeneratedResource: [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)] = ({
            let emptyElement = (SKTileGroup(), SKTileDefinition())
            let tileTypeCount = TileType.count
            var array = [(tileGroup: SKTileGroup, tileDefinition: SKTileDefinition)](repeating: emptyElement, count: tileTypeCount)

            for tileTypeValue in 0..<tileTypeCount {
                let tileType = TileType(rawValue: tileTypeValue)!
                let tileTexture = SKTexture(imageNamed: tileType.resourceName)
                let tileDefinition = SKTileDefinition(texture: tileTexture)
                let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
                array[tileTypeValue] = (tileGroup, tileDefinition)
            }

            return array
        })()
    }

    override class var count: Int {
        return TileType.Resource.name.count
    }

    static var tileGroups: [SKTileGroup] {
        return TileType.Resource.GeneratedResource.map { $0.tileGroup }
    }

    // TODO: upgrade readability
    override init?(rawValue: RawValue) {
        super.init(rawValue: rawValue)
    }

    var resourceName: String {
        return TileType.Resource.name[self.rawValue]
    }

    var tileGroup: SKTileGroup {
        return TileType.Resource.GeneratedResource[self.rawValue].tileGroup
    }

    var tileDefinition: SKTileDefinition {
        return TileType.Resource.GeneratedResource[self.rawValue].tileDefinition
    }

}

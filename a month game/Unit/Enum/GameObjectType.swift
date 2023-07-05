//
//  GameObjectType.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/24.
//

import Foundation
import SpriteKit

enum GameObjectType: Int, CaseIterable {

    typealias ResourceType = (
        resourceName: String,
        walkSpeed: Double,
        isTile: Bool,
        isPickable: Bool
    )

    case none
    case caveHoleTile
    case waterTile
    case caveCeilTile
    case sandTile
    case clayTile
    case cobblestoneTile
    case dirtTile
    case woodFloorTile
    case treeOak
    case pineTree
    case woodWall
    case stone
    case dirt
    case sand
    case clay
    case leaves
    case woodStick
    case woodLog
    case treeOakSeed
    case pineCone
    case stoneAxe
    case stoneShovel
    case stonePickaxe
    case leafBag

    init?(from goMO: GameObjectMO) {
        self.init(rawValue: goMO.type)
    }

    private static let resources: [ResourceType] = [
        ("game_object_none", -1.0, false, false),
        ("game_object_cave_hole_tile", -1.0, true, false),
        ("game_object_water_tile", 0.25, true, false),
        ("game_object_cave_ceil_tile", 0.25, true, false),
        ("game_object_sand_tile", 0.5, true, false),
        ("game_object_clay_tile", 0.5, true, false),
        ("game_object_cobblestone_tile", 0.75, true, false),
        ("game_object_dirt_tile", 1.0, true, false),
        ("game_object_wood_floor_tile", 1.0, true, false),
        ("game_object_tree_oak", -1.0, false, false),
        ("game_object_pine_tree", -1.0, false, false),
        ("game_object_wood_wall", -1.0, false, false),
        ("game_object_stone", 1.0, false, true),
        ("game_object_dirt", 1.0, false, true),
        ("game_object_sand", 1.0, false, true),
        ("game_object_clay", 1.0, false, true),
        ("game_object_leaves", 1.0, false, true),
        ("game_object_wood_stick", 1.0, false, true),
        ("game_object_wood_log", 1.0, false, true),
        ("game_object_tree_oak_seed", 1.0, false, true),
        ("game_object_pine_cone", 1.0, false, true),
        ("game_object_stone_axe", 1.0, false, true),
        ("game_object_stone_shovel", 1.0, false, true),
        ("game_object_stone_pickaxe", 1.0, false, true),
        ("game_object_leaf_bag", 1.0, false, true),
    ]

    private static let textures: [SKTexture] = ({
        var textures: [SKTexture] = [SKTexture](repeating: SKTexture(), count: GameObjectType.caseCount)

        for (index, resource) in resources.enumerated() {
            let texture = SKTexture(imageNamed: resource.resourceName)
            texture.filteringMode = .nearest
            textures[index] = texture
        }

        return textures
    })()

    static var caseCount: Int { GameObjectType.allCases.count }

    var typeID: Int32 { Int32(self.rawValue) }
    var resources: [ResourceType] { GameObjectType.resources }
    var texture: SKTexture { GameObjectType.textures[self.rawValue] }

    var walkSpeed: Double { self.resources[self.rawValue].walkSpeed }
    var isWalkable: Bool { self.walkSpeed != -1.0 }
    var isPickable: Bool { self.resources[self.rawValue].isPickable }
    var isTile: Bool { self.resources[self.rawValue].isTile }

}

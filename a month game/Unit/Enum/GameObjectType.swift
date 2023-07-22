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
        sizeScale: Double,
        hasCover: Bool,
        walkSpeed: Double,
        invCapacity: Int,
        isFloor: Bool,
        isMovable: Bool,
        isPickable: Bool,
        actionTimeout: Double
    )

    case none
    case grassFloor
    case dirtFloor
    case clayFloor
    case caveCeilFloor
    case caveHoleFloor
    case waterFloor
    case cobblestoneFloor
    case sandFloor
    case stone
    case dirt
    case clay
    case sand
    case weed
    case weedLeaves
    case vine
    case vineStem
    case plantBarleySeed
    case plantBarleySapling
    case plantBarley
    case treeOakSeed
    case treeOakSapling
    case treeOak
    case pineCone
    case pineTree
    case woodStick
    case woodLog
    case woodBoard
    case axe
    case shovel
    case pickaxe
    case sickle
    case saw
    case leafBag
    case vineBasket
    case woodenBox
    case woodTileFloor
    case woodWall

    init?(from goMO: GameObjectMO) {
        self.init(rawValue: goMO.type)
    }

    private static let resources: [ResourceType] = [
        ("game_object_none", 0.0, false, -1.0, 0, false, false, false, -1.0),
        ("game_object_grass_floor", 1.0, false, 1.0, 0, true, false, false, -1.0),
        ("game_object_dirt_floor", 1.0, false, 1.0, 0, true, false, false, -1.0),
        ("game_object_clay_floor", 1.0, false, 0.5, 0, true, false, false, -1.0),
        ("game_object_cave_ceil_floor", 1.0, false, 0.25, 0, true, false, false, -1.0),
        ("game_object_cave_hole_floor", 1.0, false, -1.0, 0, true, false, false, -1.0),
        ("game_object_water_floor", 1.0, false, 0.25, 0, true, false, false, -1.0),
        ("game_object_cobblestone_floor", 1.0, false, 0.75, 0, true, false, false, -1.0),
        ("game_object_sand_floor", 1.0, false, 0.5, 0, true, false, false, -1.0),
        ("game_object_stone", 0.5, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_dirt", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_clay", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_sand", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_weed", 0.75, true, 0.75, 0, false, false, false, 302400.0),
        ("game_object_weed_leaves", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_vine", 1.0, false, 0.50, 0, false, false, false, -1.0),
        ("game_object_vine_stem", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_plant_barley_seed", 0.5, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_plant_barley_sapling", 0.75, true, 1.0, 0, false, false, false, 302400.0),
        ("game_object_plant_barley", 1.0, true, 0.75, 0, false, false, false, -1.0),
        ("game_object_tree_oak_seed", 0.5, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_tree_oak_sapling", 0.5, false, 1.0, 0, false, false, false, 604800.0),
        ("game_object_tree_oak", 1.0, false, -1.0, 0, false, false, false, -1.0),
        ("game_object_pine_cone", 0.5, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_pine_tree", 1.0, false, -1.0, 0, false, false, false, -1.0),
        ("game_object_wood_stick", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_wood_log", 1.0, false, 1.0, 0, false, true, false, -1.0),
        ("game_object_wood_board", 0.75, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_axe", 1.0, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_shovel", 1.0, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_pickaxe", 1.0, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_sickle", 1.0, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_saw", 1.0, false, 1.0, 0, false, true, true, 300.0),
        ("game_object_leaf_bag", 0.75, false, 1.0, 2, false, true, true, -1.0),
        ("game_object_vine_basket", 1.0, false, 1.0, 3, false, true, true, -1.0),
        ("game_object_wooden_box", 1.0, false, 1.0, 4, false, true, true, -1.0),
        ("game_object_wood_tile_floor", 1.0, false, 1.0, 0, true, false, false, -1.0),
        ("game_object_wood_wall", 1.0, false, -1.0, 0, false, false, false, -1.0),
    ]

    private static let texture: [SKTexture] = ({
        var textures: [SKTexture] = []
        textures.reserveCapacity(GameObjectType.caseCount)

        for (index, resource) in resources.enumerated() {
            let texture = SKTexture(imageNamed: resource.resourceName)
            texture.filteringMode = .nearest

            textures.append(texture)
        }

        return textures
    })()

    static var caseCount: Int { GameObjectType.allCases.count }

    var typeID: Int32 { Int32(self.rawValue) }

    var resource: ResourceType { GameObjectType.resources[self] }

    var texture: SKTexture { GameObjectType.texture[self] }

    var sizeScale: Double { self.resource.sizeScale }

    var hasCover: Bool { self.resource.hasCover }
    
    var walkSpeed: Double { self.resource.walkSpeed }
    var isWalkable: Bool { self.walkSpeed != -1.0 }

    var invCapacity: Int { self.resource.invCapacity }
    var isContainer: Bool { self.invCapacity != 0 }

    var isFloor: Bool { self.resource.isFloor }
    var isMovable: Bool { self.resource.isMovable }
    var isPickable: Bool { self.resource.isPickable }

    var actionTimeout: Double { self.resource.actionTimeout }
    var hasTimeAction: Bool { self.actionTimeout != -1.0 }

}

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
        invCapacity: Int,
        layerCount: Int,
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
    case woodFloorFloor
    case weed
    case vine
    case treeOak
    case pineTree
    case woodWall
    case woodLog
    case stone
    case dirt
    case sand
    case clay
    case weedLeaves
    case vineStem
    case woodStick
    case woodBoard
    case treeOakSeed
    case pineCone
    case axe
    case shovel
    case pickaxe
    case sickle
    case saw
    case leafBag
    case vineBasket
    case woodenBox

    init?(from goMO: GameObjectMO) {
        self.init(rawValue: goMO.type)
    }

    private static let resources: [ResourceType] = [
        ("game_object_none", -1.0, 0, 1, false, false, false, -1.0),
        ("game_object_grass_floor", 1.0, 0, 1, true, false, false, -1.0),
        ("game_object_dirt_floor", 1.0, 0, 1, true, false, false, -1.0),
        ("game_object_clay_floor", 0.5, 0, 1, true, false, false, -1.0),
        ("game_object_cave_ceil_floor", 0.25, 0, 1, true, false, false, -1.0),
        ("game_object_cave_hole_floor", -1.0, 0, 1, true, false, false, -1.0),
        ("game_object_water_floor", 0.25, 0, 1, true, false, false, -1.0),
        ("game_object_cobblestone_floor", 0.75, 0, 1, true, false, false, -1.0),
        ("game_object_sand_floor", 0.5, 0, 1, true, false, false, -1.0),
        ("game_object_wood_floor_floor", 1.0, 0, 1, true, false, false, -1.0),
        ("game_object_weed", 0.75, 0, 2, false, false, false, 604800.0),
        ("game_object_vine", 0.50, 0, 1, false, false, false, -1.0),
        ("game_object_tree_oak", -1.0, 0, 1, false, false, false, -1.0),
        ("game_object_pine_tree", -1.0, 0, 1, false, false, false, -1.0),
        ("game_object_wood_wall", -1.0, 0, 1, false, false, false, -1.0),
        ("game_object_wood_log", 1.0, 0, 1, false, true, false, -1.0),
        ("game_object_stone", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_dirt", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_sand", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_clay", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_weed_leaves", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_vine_stem", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_wood_stick", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_wood_board", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_tree_oak_seed", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_pine_cone", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_axe", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_shovel", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_pickaxe", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_sickle", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_saw", 1.0, 0, 1, false, true, true, 300.0),
        ("game_object_leaf_bag", 1.0, 2, 1, false, true, true, -1.0),
        ("game_object_vine_basket", 1.0, 3, 1, false, true, true, -1.0),
        ("game_object_wooden_box", 1.0, 4, 1, false, true, true, -1.0),
    ]

    private static let textures: [[SKTexture]] = ({
        var textures: [[SKTexture]] = []
        textures.reserveCapacity(GameObjectType.caseCount)

        for (index, resource) in resources.enumerated() {
            var texturesForResource: [SKTexture] = []

            switch resource.layerCount {
            case 1:
                let texture = SKTexture(imageNamed: resource.resourceName)
                texture.filteringMode = .nearest
                texturesForResource.append(texture)
            case 2:
                var resourceName = resource.resourceName.appending("_bottom")
                var texture = SKTexture(imageNamed: resourceName)
                texture.filteringMode = .nearest
                texturesForResource.append(texture)
                resourceName = resource.resourceName.appending("_top")
                texture = SKTexture(imageNamed: resourceName)
                texture.filteringMode = .nearest
                texturesForResource.append(texture)
            default: break
            }

            textures.append(texturesForResource)
        }

        return textures
    })()

    static var caseCount: Int { GameObjectType.allCases.count }

    var typeID: Int32 { Int32(self.rawValue) }

    var resource: ResourceType { GameObjectType.resources[self] }

    var textures: [SKTexture] { GameObjectType.textures[self] }

    var invCapacity: Int { self.resource.invCapacity }
    var isContainer: Bool { self.invCapacity != 0 }

    var layerCount: Int { self.resource.layerCount }
    
    var walkSpeed: Double { self.resource.walkSpeed }
    var isWalkable: Bool { self.walkSpeed != -1.0 }

    var isFloor: Bool { self.resource.isFloor }
    var isMovable: Bool { self.resource.isMovable }
    var isPickable: Bool { self.resource.isPickable }

    var actionTimeout: Double { self.resource.actionTimeout }

}

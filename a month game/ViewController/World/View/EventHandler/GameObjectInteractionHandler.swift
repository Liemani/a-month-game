//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation

class GameObjectInteractionHandler {

    static let handler: [(GameObject, InventoryContainer) -> Void] = [
        { go, invContainer in // none

        },

        { go, invContainer in // caveHoleTile

        },

        { go, invContainer in // waterTile

        },

        { go, invContainer in // caveCeilTile
            guard let emptyInvCoord = invContainer.emptyCoord else {
                return
            }

            guard invContainer.is(equiping: .stonePickaxe) else {
                return
            }

            go.set(type: .caveHoleTile)
            let stone = GameObject(type: .stone, coord: emptyInvCoord)
            GameObjectManager.default.moveToBelongInv(stone)
        },

        { go, invContainer in // sandTile
            guard let emptyInvCoord = invContainer.emptyCoord else {
                return
            }

            guard invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .clayTile)
            let sand = GameObject(type: .sand, coord: emptyInvCoord)
            GameObjectManager.default.moveToBelongInv(sand)
        },

        { go, invContainer in // clayTile
            guard let emptyInvCoord = invContainer.emptyCoord else {
                return
            }

            guard invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .caveCeilTile)
            let clay = GameObject(type: .clay, coord: emptyInvCoord)
            GameObjectManager.default.moveToBelongInv(clay)
        },

        { go, invContainer in // cobblestoneTile
            guard let emptyInvCoord = invContainer.emptyCoord else {
                return
            }

            go.set(type: .sandTile)
            let stone = GameObject(type: .stone, coord: emptyInvCoord)
            GameObjectManager.default.moveToBelongInv(stone)
        },

        { go, invContainer in // dirtTile
            guard let emptyInvCoord = invContainer.emptyCoord else {
                return
            }

            guard invContainer.is(equiping: .stoneShovel) else {
                return
            }

            go.set(type: .clayTile)
            let dirt = GameObject(type: .dirt, coord: emptyInvCoord)
            GameObjectManager.default.moveToBelongInv(dirt)
        },

        { go, invContainer in // woodFloorTile

        },

        { go, invContainer in // stone

        },

        { go, invContainer in // dirt

        },

        { go, invContainer in // sand

        },

        { go, invContainer in // clay

        },

        { go, invContainer in // pineCone

        },

        { go, invContainer in // pineTree

        },

        { go, invContainer in // woodWall

        },

        { go, invContainer in // woodStick

        },

        { go, invContainer in // stoneAxe

        },

        { go, invContainer in // stoneShovel

        },

        { go, invContainer in // stonePickaxe

        },

        { go, invContainer in // leafBag

        },
    ]

}

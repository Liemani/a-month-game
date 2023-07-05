//
//  GameObjectInteractionHandler.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/05.
//

import Foundation

class GameObjectInteractionHandler {

    static let handler: [(WorldScene, GameObject) -> Void] = [
        { scene, go in // none

        },

        { scene, go in // caveHoleTile

        },

        { scene, go in // waterTile

        },

        { scene, go in // caveCeilTile

        },

        { scene, go in // sandTile

        },

        { scene, go in // clayTile

        },

        { scene, go in // cobblestoneTile
            guard let emptyInvCoord = scene.invContainer.emptyCoord else {
                return
            }

            go.set(type: .sandTile)
            let stone = GameObject(type: .stone, coord: emptyInvCoord)
            GameObjectManager.default.moveToBelongInv(stone)
        },

        { scene, go in // dirtTile

        },

        { scene, go in // woodFloorTile

        },

        { scene, go in // pineCone

        },

        { scene, go in // pineTree

        },

        { scene, go in // woodWall

        },

        { scene, go in // woodStick

        },

        { scene, go in // stone

        },

        { scene, go in // stoneAxe

        },

        { scene, go in // stoneShovel

        },

        { scene, go in // stonePickaxe

        },

        { scene, go in // leafBag

        },
    ]

}

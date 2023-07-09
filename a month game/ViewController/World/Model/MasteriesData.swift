//
//  MasteriesData.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/09.
//

import Foundation

struct GOInteractionMasteryDatasKey: Hashable {

    let srcType: GameObjectType
    let dstType: GameObjectType

    init(from srcType: GameObjectType, to dstType: GameObjectType) {
        self.srcType = srcType
        self.dstType = dstType
    }

}

class MasteriesData {

    var interactionMasteryDatas: [GameObjectType: InteractionMasteryData]
    var goInteractionMasteryDatas: [GOInteractionMasteryDatasKey: GOInteractionMasteryData]
    var craftMasteryDatas: [GameObjectType: CraftMasteryData]

    init() {
        self.interactionMasteryDatas = [:]
        self.goInteractionMasteryDatas = [:]
        self.craftMasteryDatas = [:]

        let interactionMasteryDatas = Services.default.interactionMasteryServ.load()

        for interactionMasteryData in interactionMasteryDatas {
            self.interactionMasteryDatas[interactionMasteryData.dstType] = interactionMasteryData
        }

        let goInteractionMasteryDatas = Services.default.goInteractionMasteryServ.load()

        for goInteractionMasteryData in goInteractionMasteryDatas {
            let key = GOInteractionMasteryDatasKey(
                from: goInteractionMasteryData.srcType,
                to: goInteractionMasteryData.dstType)
            self.goInteractionMasteryDatas[key] = goInteractionMasteryData
        }

        let craftMasteryDatas = Services.default.craftMasteryServ.load()

        for craftMasteryData in craftMasteryDatas {
            self.craftMasteryDatas[craftMasteryData.dstType] = craftMasteryData
        }
    }

    func updateInteraction(_ dst: GameObject, expIncrement: Int32) {
        if let interactionMasteryData = self.interactionMasteryDatas[dst.type] {
            interactionMasteryData.increase(exp: expIncrement)

            return
        }

        let interactionMasteryData = InteractionMasteryData(type: dst.type)
        self.interactionMasteryDatas[interactionMasteryData.dstType] = interactionMasteryData
        interactionMasteryData.increase(exp: expIncrement)
    }

    func updateInteraction(from src: GameObject, to dst: GameObject, expIncrement: Int32) {
        let key = GOInteractionMasteryDatasKey(from: src.type, to: dst.type)

        if let goInteractionMasteryData = self.goInteractionMasteryDatas[key] {
            goInteractionMasteryData.increase(exp: expIncrement)

            return
        }

        let goInteractionMasteryData = GOInteractionMasteryData(from: src.type, to: dst.type)
        self.goInteractionMasteryDatas[key] = goInteractionMasteryData
        goInteractionMasteryData.increase(exp: expIncrement)
    }

    func updateCraft(_ dst: GameObject, expIncrement: Int32) {
        if let craftMasteryData = self.craftMasteryDatas[dst.type] {
            craftMasteryData.increase(exp: expIncrement)

            return
        }

        let craftMasteryData = CraftMasteryData(type: dst.type)
        self.craftMasteryDatas[craftMasteryData.dstType] = craftMasteryData
        craftMasteryData.increase(exp: expIncrement)
    }

}

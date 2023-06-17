//
//  Container.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/26.
//

import Foundation

/// Bijective model
///  Concentrate data input output without limit
class ContainerModel {

    private var goMOToGO: [GameObjectMO: GameObjectNode] = [:]
    private var goToGOMO: [GameObjectNode: GameObjectMO] = [:]

    var goMOs: Dictionary<GameObjectMO, GameObjectNode>.Keys {
        return self.goMOToGO.keys
    }

    // MARK: - subscript
    subscript(goMO: GameObjectMO) -> GameObjectNode? {
        get { return self.goMOToGO[goMO] }
        set(newGO) {
            if let oldGO = self.goMOToGO[goMO] {
                self.goToGOMO[oldGO] = nil
                self.goMOToGO[goMO] = newGO
                if let newGO = newGO {
                    self.goToGOMO[newGO] = goMO
                }
            } else {
                self.goMOToGO[goMO] = newGO
                if let newGO = newGO {
                    self.goToGOMO[newGO] = goMO
                }
            }
        }
    }

    subscript(go: GameObjectNode) -> GameObjectMO? {
        get { return self.goToGOMO[go] }
        set(newGOMO) {
            if let oldGOMO = self.goToGOMO[go] {
                self.goMOToGO[oldGOMO] = nil
                self.goToGOMO[go] = newGOMO
                if let newGOMO = newGOMO {
                    self.goMOToGO[newGOMO] = go
                }
            } else {
                self.goToGOMO[go] = newGOMO
                if let newGOMO = newGOMO {
                    self.goMOToGO[newGOMO] = go
                }
            }
        }
    }

    // MARK: - remove
    func remove(_ goMO: GameObjectMO) -> GameObjectNode? {
        if let go = self.goMOToGO[goMO] {
            self.goMOToGO[goMO] = nil
            self.goToGOMO[go] = nil
            return go
        }
        return nil
    }

    func remove(_ go: GameObjectNode) -> GameObjectMO? {
        if let goMO = self.goToGOMO[go] {
            self.goMOToGO[goMO] = nil
            self.goToGOMO[go] = nil
            return goMO
        }
        return nil
    }

    var goMOKeys: Dictionary<GameObjectMO, GameObjectNode>.Keys {
        return self.goMOToGO.keys
    }

    var goKeys: Dictionary<GameObjectNode, GameObjectMO>.Keys {
        return self.goToGOMO.keys
    }

}

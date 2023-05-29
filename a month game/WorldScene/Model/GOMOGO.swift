//
//  GOToGOMO.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/26.
//

import Foundation

/// A model that contains all game object managed object and game object.
class GOMOGO {

    /// Objects are stored according to container type
    private var containers: [ContainerModel]

    init() {
        let arrayCount = ContainerType.allCases.count
        let emptyContainer = ContainerModel()
        self.containers = [ContainerModel](repeating: emptyContainer, count: arrayCount)
    }

    var field: ContainerModel {
        return self.containers[ContainerType.field]
    }

    var inventory: ContainerModel {
        return self.containers[ContainerType.inventory]
    }

    var thirdHand: ContainerModel {
        return self.containers[ContainerType.thirdHand]
    }

    var goMOsInField: Dictionary<GameObjectMO, GameObject>.Keys {
        return self.containers[ContainerType.field].goMOs
    }

    var goMOsInInventory: Dictionary<GameObjectMO, GameObject>.Keys {
        return self.containers[ContainerType.inventory].goMOs
    }

    var goMOsInThirdHand: Dictionary<GameObjectMO, GameObject>.Keys {
        return self.containers[ContainerType.thirdHand].goMOs
    }

    var gos: CombineSequence<GameObject> {
        var sequences: [any Sequence<GameObject>] = []
        for container in containers {
            sequences.append(container.goKeys)
        }
        return CombineSequence(sequences: sequences)
    }

    var goMOs: CombineSequence<GameObjectMO> {
        var sequences: [any Sequence<GameObjectMO>] = []
        for container in containers {
            sequences.append(container.goMOKeys)
        }
        return CombineSequence(sequences: sequences)
    }

    func container(for goMO: GameObjectMO) -> ContainerModel? {
        if let containerTypeRawValue = goMO.containerTypeRawValue {
            return self.containers[containerTypeRawValue]
        }
        return nil
    }

    subscript(goMO: GameObjectMO) -> GameObject? {
        get {
            if let container = self.container(for: goMO) {
                return container[goMO]
            }
            return nil
        }
        set(go) {
            if let container = self.container(for: goMO) {
                container[goMO] = go
            }
        }
    }

    subscript(go: GameObject) -> GameObjectMO? {
        get {
            for container in self.containers {
                if let goMO = container[go] {
                    return goMO
                }
            }
            return nil
        }
        set(newGOMO) {
            if let newGOMO = newGOMO {
                self[newGOMO] = go
            } else {
                for container in self.containers {
                    if container[go] != nil {
                        container[go] = newGOMO
                        return
                    }
                }
            }
        }
    }

    func remove(_ goMO: GameObjectMO) -> GameObject? {
        return self.container(for: goMO)?.remove(goMO)
    }

    func remove(_ go: GameObject) -> GameObjectMO? {
        for container in containers {
            if container[go] != nil {
                return container.remove(go)
            }
        }
        return nil
    }

    func moveContainer(_ goMO: GameObjectMO, from source: ContainerType, to destination: ContainerType) {
        let go = self.containers[source].remove(goMO)
        self.containers[destination][goMO] = go
    }

}

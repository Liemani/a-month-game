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
    private var containers: [Container]

    init() {
        let arrayCount = ContainerType.allCases.count
        let emptyContainer = Container()
        self.containers = [Container](repeating: emptyContainer, count: arrayCount)
    }

    var field: Container {
        return self.containers[ContainerType.field]
    }

    var inventory: Container {
        return self.containers[ContainerType.inventory]
    }

    var thirdHand: Container {
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

    var gos: sequencesIterator<Dictionary<GameObject, GameObjectMO>.Keys> {
        var sequences: [Dictionary<GameObject, GameObjectMO>.Keys] = []
        for container in containers {
            sequences.append(container.goKeys)
        }
        return sequencesIterator(sequences: sequences)
    }

    var goMOs: sequencesIterator<Dictionary<GameObjectMO, GameObject>.Keys> {
        var sequences: [Dictionary<GameObjectMO, GameObject>.Keys] = []
        for container in containers {
            sequences.append(container.goMOKeys)
        }
        return sequencesIterator(sequences: sequences)
    }

    func container(for goMO: GameObjectMO) -> Container? {
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

struct sequencesIterator<S>: Sequence, IteratorProtocol where S: Sequence {

    typealias Element = S.Element

    private var sequences: [S.Iterator?] = []
    private var currentIndex: Int = 0

    init(sequences: [S]) {
        for sequence in sequences {
            self.sequences.append(sequence.makeIterator())
        }
    }

    mutating func next() -> Element? {
        while true {
            guard currentIndex < self.sequences.count else {
                return nil
            }

            let currentElement = sequences[currentIndex]!.next()

            if currentElement != nil {
                return currentElement
            }

            self.sequences[currentIndex] = nil
            currentIndex += 1
        }
    }

}

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

    var goMOsInField: Dictionary<GameObjectMO, GameObject>.Keys {
        return self.containers[ContainerType.field].goMOs
    }

    var goMOsInInventory: Dictionary<GameObjectMO, GameObject>.Keys {
        return self.containers[ContainerType.inventory].goMOs
    }

    var goMOsInThirdHand: Dictionary<GameObjectMO, GameObject>.Keys {
        return self.containers[ContainerType.thirdHand].goMOs
    }

    var gos: IteratorSequence<DictionaryKeysArrayIterator<GameObject, GameObjectMO>> {
        var dictionaryKeysArray: [Dictionary<GameObject, GameObjectMO>.Keys] = []
        for container in containers {
            dictionaryKeysArray.append(container.goKeys)
        }
        return IteratorSequence(DictionaryKeysArrayIterator(dictionaryKeysArray: dictionaryKeysArray))
    }

    var goMOs: IteratorSequence<DictionaryKeysArrayIterator<GameObjectMO, GameObject>> {
        var dictionaryKeysArray: [Dictionary<GameObjectMO, GameObject>.Keys] = []
        for container in containers {
            dictionaryKeysArray.append(container.goMOKeys)
        }
        return IteratorSequence(DictionaryKeysArrayIterator(dictionaryKeysArray: dictionaryKeysArray))
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
                    if let oldGOMO = container[go] {
                        container[go] = newGOMO
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
            if let goMO = container[go] {
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

struct DictionaryKeysArrayIterator<Key, Value>: IteratorProtocol
where Key: Hashable {
    typealias Element = Key

    private var dkiArray: [Dictionary<Key, Value>.Keys.Iterator?]
    private var currentDKIArrayIndex: Int

    init(dictionaryKeysArray: [Dictionary<Key, Value>.Keys]) {
        self.dkiArray = []
        for dictionaryKeys in dictionaryKeysArray {
            self.dkiArray.append(dictionaryKeys.makeIterator())
        }

        self.currentDKIArrayIndex = 0
    }

    mutating func next() -> Element? {
        var dki: Dictionary<Key, Value>.Keys.Iterator!

        while true {
            guard currentDKIArrayIndex < self.dkiArray.count else {
                return nil
            }

            dki = dkiArray[currentDKIArrayIndex]!
            let currentElement = dki.next()

            if currentElement != nil {
                return currentElement
            }

            self.dkiArray[currentDKIArrayIndex] = nil
            currentDKIArrayIndex += 1
        }
    }
}

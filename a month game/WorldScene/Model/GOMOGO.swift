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

//    var goMOs: IteratorSequence<DictionaryKeysArrayIterator<GameObjectMO, GameObject>> {
//        return IteratorSequence(DictionaryKeysArrayIterator(dictionaryArray: self.containers))
//    }

    subscript(key: GameObjectMO) -> GameObject? {
        get {
            guard let containerTypeRawValue = key.containerTypeRawValue else {
                return nil
            }
            return self.containers[containerTypeRawValue][key]
        }
        set(value) {
            if let containerTypeRawValue = key.containerTypeRawValue {
                self.containers[containerTypeRawValue][key] = value
            }
        }
    }

    subscript(key: GameObject) -> GameObjectMO? {
        get {
            for container in self.containers {
                if let value = container[key] {
                    return value
                }
            }
            return nil
        }
        set(value) {
            for container in self.containers {
                if let
            }
        }
    }

    func removeValue(forKey key: GameObjectMO) -> GameObject? {
        if let containerTypeRawValue = key.containerTypeRawValue {
            return self.containers[containerTypeRawValue].removeValue(forKey: key)
        }
        return nil
    }

    func moveContainer(_ goMO: GameObjectMO, from: ContainerType, to: ContainerType) {
        let go = self.removeValue(forKey: goMO)
        self[goMO] = go


    }

}

struct DictionaryKeysArrayIterator<Key, Value>: IteratorProtocol
where Key: Hashable {
    typealias Element = Key

    private var dkiArray: [Dictionary<Key, Value>.Keys.Iterator?]
    private var currentDKIArrayIndex: Int

    init(dictionaryArray: [Dictionary<Key, Value>]) {
        self.dkiArray = []
        for dictionary in dictionaryArray {
            self.dkiArray.append(dictionary.keys.makeIterator())
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

//class GOMOToGOArray {
//    /// game object is collected by container type
//    private var goMOToGOArray: [[GameObjectMO: GameObject]]
//    private var goToGOMOArray: [[GameObject: GameObjectMO]]
//
//    init() {
//        let arrayCount = ContainerType.allCases.count
//        let emptyDictionary: [GameObjectMO: GameObject] = [:]
//        self.goMOToGOArray = [[GameObjectMO: GameObject]](repeating: emptyDictionary, count: arrayCount)
//    }
//
//    var goMOsInField: Dictionary<GameObjectMO, GameObject>.Keys {
//        return self.goMOToGOArray[ContainerType.field].keys
//    }
//
//    var goMOsInInventory: Dictionary<GameObjectMO, GameObject>.Keys {
//        return self.goMOToGOArray[ContainerType.inventory].keys
//    }
//
//    var goMOsInThirdHand: Dictionary<GameObjectMO, GameObject>.Keys {
//        return self.goMOToGOArray[ContainerType.thirdHand].keys
//    }
//
//    var goMOs: IteratorSequence<DictionaryKeysArrayIterator<GameObjectMO, GameObject>> {
//        return IteratorSequence(DictionaryKeysArrayIterator(dictionaryArray: self.goMOToGOArray))
//    }
//
//    subscript(key: GameObjectMO) -> GameObject? {
//        get {
//            for goMOToGO in self.goMOToGOArray {
//                if let go = goMOToGO[key] {
//                    return go
//                }
//            }
//            return nil
//        }
//        set(value) {
//            if let containerTypeRawValue = key.containerTypeRawValue {
//                self.goMOToGOArray[containerTypeRawValue][key] = value
//            }
//        }
//    }
//
//    func removeValue(forKey key: GameObjectMO) -> GameObject? {
//        if let containerTypeRawValue = key.containerTypeRawValue {
//            return self.goMOToGOArray[containerTypeRawValue].removeValue(forKey: key)
//        }
//        return nil
//    }
//
//    func moveContainer(_ goMO: GameObjectMO, from: ContainerType, to: ContainerType) {
//        let go = self.removeValue(forKey: goMO)
//        self[goMO] = go
//
//
//    }
//
//}

//
//  GOToGOMO.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/26.
//

import Foundation

struct GOToGOMOArray {
    /// game object is collected by container type
    private var goToGOMOArray: [[GameObject: GameObjectMO]] = []

    var goMOsInField: Dictionary<GameObject, GameObjectMO>.Values {
        return self.goToGOMOArray[ContainerType.field].values
    }

    var goMOsInInventory: Dictionary<GameObject, GameObjectMO>.Values {
        return self.goToGOMOArray[ContainerType.inventory].values
    }

    var goMOsInThirdHand: Dictionary<GameObject, GameObjectMO>.Values {
        return self.goToGOMOArray[ContainerType.thirdHand].values
    }

    var goMOs: DictionaryValuesIteratorArrayIterator<GameObject, GameObjectMO> {
        return DictionaryValuesIteratorArrayIterator(dictionaryArray: goToGOMOArray)
    }

    subscript(go: GameObject) -> GameObjectMO? {
        for goToGOMO in self.goToGOMOArray {
            if let goMO = goToGOMO[go] {
                return goMO
            }
        }
        return nil
    }
}

struct DictionaryValuesIteratorArrayIterator<Key, Value>: IteratorProtocol
where Key: Hashable {
    typealias Element = Value

    private var dviArray: [Dictionary<Key, Value>.Values.Iterator]
    private var currentDVIArrayIndex = 0

    init(dictionaryArray: [Dictionary<Key, Value>]) {
        self.dviArray = []
        for dictionary in dictionaryArray {
            self.dviArray.append(dictionary.values.makeIterator())
        }
    }

    mutating func next() -> Element? {
        guard currentDVIArrayIndex < dviArray.count else {
            return nil
        }

        var dvi = dviArray[currentDVIArrayIndex]
        let currentElement = dvi.next()

        if currentElement == nil {
            currentDVIArrayIndex += 1
        }

        return currentElement
    }
}

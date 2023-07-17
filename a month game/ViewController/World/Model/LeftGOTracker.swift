//
//  LeftGOTracker.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/17.
//

import Foundation
import QuartzCore

protocol HasIDProtocol {

    associatedtype ID: Hashable

    var id: ID { get }

}

class HasIDDictionary<Value>: Sequence
where Value: HasIDProtocol {

    var dict: [Value.ID: Value]

    init() {
        dict = [:]
    }

    func add(_ value: Value) {
        self.dict[value.id] = value
    }

    func remove(_ value: Value) {
        self.dict[value.id] = nil
    }

    func remove(_ id: Value.ID) {
        self.dict[id] = nil
    }

    func removeAll() {
        self.dict.removeAll()
    }

    func makeIterator() -> some IteratorProtocol<Value> {
        return self.dict.values.makeIterator()
    }

}

class LeftGOTracker: HasIDDictionary<GameObject> {

}

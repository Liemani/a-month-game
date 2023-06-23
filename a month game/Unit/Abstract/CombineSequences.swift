//
//  Iterator.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation

//func combineIterators(iterators: [any IteratorProtocol]) -> some IteratorProtocol {
//    var iteratorIndex = 0
//
//    return AnyIterator {
//        while iteratorIndex < iterators.count {
//            if let nextElement = iterators[iteratorIndex].next() {
//                return nextElement
//            } else {
//                iteratorIndex += 1
//            }
//        }
//        return nil
//    }
//}
//
//func combineSequencesIntoIterator<T>(sequences: [AnySequence<T>]) -> AnyIterator<T> {
//    let iterators = sequences.map { $0.makeIterator() }
//    var iteratorIndex = 0
//
//    return AnyIterator {
//        while iteratorIndex < iterators.count {
//            if let nextElement = iterators[iteratorIndex].next() {
//                return nextElement
//            } else {
//                iteratorIndex += 1
//            }
//        }
//        return nil
//    }
//}

struct CombineSequences<Element>: Sequence, IteratorProtocol {

    private var iterators: [any IteratorProtocol<Element>]
    private var currentIndex: Int = 0

    init(sequences: [any Sequence<Element>]) {
        self.iterators = [any IteratorProtocol<Element>]()
        self.iterators.reserveCapacity(sequences.count)
        for sequence in sequences {
            self.iterators.append(sequence.makeIterator() as! any IteratorProtocol<Element>)
        }
    }

    mutating func next() -> Element? {
        while self.currentIndex < self.iterators.count {
            if let nextElement = iterators[self.currentIndex].next() {
                return nextElement
            } else {
                self.currentIndex += 1
            }
        }
        return nil
    }

}

//struct MaterialInRecipeSequence<Element>: Sequence, IteratorProtocol where Element: BelongEquatableType {
//
//    typealias ElementType = Element.TypeObject
//
//    var recipe: [(type: ElementType, count: Int)]
//    var materialIterator: any IteratorProtocol<Element>
//
//    init(recipe: [(ElementType, Int)], materials: any Sequence<Element>) {
//        self.recipe = recipe
//        self.materialIterator = materials.makeIterator() as! any IteratorProtocol<Element>
//    }
//
//    mutating func next() -> Element? {
//        while true {
//            guard let material = self.materialIterator.next() else {
//                return nil
//            }
//
//            var isReady: Bool = true
//            for index in 0..<recipe.count {
//                if recipe[index].count != 0 {
//                    isReady = false
//                    if recipe[index].type == material.type {
//                        recipe[index].count -= 1
//                        return material
//                    }
//                }
//            }
//            if isReady {
//                return nil
//            }
//        }
//    }
//
//}
//
//protocol BelongEquatableType {
//
//    associatedtype TypeObject where TypeObject: Equatable
//
//    var type: TypeObject { get }
//
//}

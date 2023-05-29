//
//  Iterator.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/29.
//

import Foundation

struct CombineSequence<Element>: Sequence, IteratorProtocol {

    private var sequences: [(any IteratorProtocol<Element>)?]
    private var currentIndex: Int = 0

    init(sequences: [any Sequence<Element>]) {
        self.sequences = [(any IteratorProtocol<Element>)?](repeating: nil, count: sequences.count)
        for (index, sequence) in sequences.enumerated() {
            self.sequences[index] = sequence.makeIterator() as! (any IteratorProtocol<Element>)?
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

struct MaterialInRecipeIteratorSequence<Element>: Sequence, IteratorProtocol where Element: BelongEquatableType {

    typealias ElementType = Element.TypeObject

    var recipe: [(type: ElementType, count: Int)]
    var materialIterator: any IteratorProtocol<Element>

    init(recipe: [(ElementType, Int)], materials: any Sequence<Element>) {
        self.recipe = recipe
        self.materialIterator = materials.makeIterator() as! any IteratorProtocol<Element>
    }

    mutating func next() -> Element? {
        while true {
            guard let material = self.materialIterator.next() else {
                return nil
            }

            var isReady: Bool = true
            for index in 0..<recipe.count {
                if recipe[index].count != 0 {
                    isReady = false
                    if recipe[index].type == material.type {
                        recipe[index].count -= 1
                        return material
                    }
                }
            }
            if isReady {
                return nil
            }
        }
    }

}

protocol BelongEquatableType {

    associatedtype TypeObject where TypeObject: Equatable

    var type: TypeObject { get }

}

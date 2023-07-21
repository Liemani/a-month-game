//
//  Matrix33.swift
//  a month game
//
//  Created by 박정훈 on 2023/07/21.
//

import Foundation
import SpriteKit

class SKNodeMatrix33<Element: SKNode> {

    private var _content: [Element]
    var content: [Element] { self._content }

    init() {
        self._content = []
        self._content.reserveCapacity(9)

        for _ in 0 ..< 9 {
            self._content.append(Element())
        }
    }

    subscript(index: Int) -> Element {
        get { self._content[index] }
        set { self._content[index] = newValue }
    }

    func element(_ coord: Coordinate<Int>) -> Element {
        return self[Direction9.rawValue(coord - 1)]
    }

    func shift(direction: Direction4) {
        switch direction {
        case .east:
            let temp1 = self._content[2]
            let temp2 = self._content[5]
            let temp3 = self._content[8]
            self._content[2] = self._content[1]
            self._content[5] = self._content[4]
            self._content[8] = self._content[7]
            self._content[1] = self._content[0]
            self._content[4] = self._content[3]
            self._content[7] = self._content[6]
            self._content[0] = temp1
            self._content[3] = temp2
            self._content[6] = temp3
            let temp4 = self._content[0].position
            let temp5 = self._content[3].position
            let temp6 = self._content[6].position
            self._content[0].position = self._content[1].position
            self._content[3].position = self._content[4].position
            self._content[6].position = self._content[7].position
            self._content[1].position = self._content[2].position
            self._content[4].position = self._content[5].position
            self._content[7].position = self._content[8].position
            self._content[2].position = temp4
            self._content[5].position = temp5
            self._content[8].position = temp6
        case .south:
            let temp1 = self._content[0]
            let temp2 = self._content[1]
            let temp3 = self._content[2]
            self._content[0] = self._content[3]
            self._content[1] = self._content[4]
            self._content[2] = self._content[5]
            self._content[3] = self._content[6]
            self._content[4] = self._content[7]
            self._content[5] = self._content[8]
            self._content[6] = temp1
            self._content[7] = temp2
            self._content[8] = temp3
            let temp4 = self._content[6].position
            let temp5 = self._content[7].position
            let temp6 = self._content[8].position
            self._content[6].position = self._content[3].position
            self._content[7].position = self._content[4].position
            self._content[8].position = self._content[5].position
            self._content[3].position = self._content[0].position
            self._content[4].position = self._content[1].position
            self._content[5].position = self._content[2].position
            self._content[0].position = temp4
            self._content[1].position = temp5
            self._content[2].position = temp6
        case .west:
            let temp1 = self._content[0]
            let temp2 = self._content[3]
            let temp3 = self._content[6]
            self._content[0] = self._content[1]
            self._content[3] = self._content[4]
            self._content[6] = self._content[7]
            self._content[1] = self._content[2]
            self._content[4] = self._content[5]
            self._content[7] = self._content[8]
            self._content[2] = temp1
            self._content[5] = temp2
            self._content[8] = temp3
            let temp4 = self._content[2].position
            let temp5 = self._content[5].position
            let temp6 = self._content[8].position
            self._content[2].position = self._content[1].position
            self._content[5].position = self._content[4].position
            self._content[8].position = self._content[7].position
            self._content[1].position = self._content[0].position
            self._content[4].position = self._content[3].position
            self._content[7].position = self._content[6].position
            self._content[0].position = temp4
            self._content[3].position = temp5
            self._content[6].position = temp6
        case .north:
            let temp1 = self._content[6]
            let temp2 = self._content[7]
            let temp3 = self._content[8]
            self._content[6] = self._content[3]
            self._content[7] = self._content[4]
            self._content[8] = self._content[5]
            self._content[3] = self._content[0]
            self._content[4] = self._content[1]
            self._content[5] = self._content[2]
            self._content[0] = temp1
            self._content[1] = temp2
            self._content[2] = temp3
            let temp4 = self._content[0].position
            let temp5 = self._content[1].position
            let temp6 = self._content[2].position
            self._content[0].position = self._content[3].position
            self._content[1].position = self._content[4].position
            self._content[2].position = self._content[5].position
            self._content[3].position = self._content[6].position
            self._content[4].position = self._content[7].position
            self._content[5].position = self._content[8].position
            self._content[6].position = temp4
            self._content[7].position = temp5
            self._content[8].position = temp6
        }
    }

}

extension SKNodeMatrix33: Sequence {

    func makeIterator() -> some IteratorProtocol<Element> {
        return self._content.makeIterator()
    }

}

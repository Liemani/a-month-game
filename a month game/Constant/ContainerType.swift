//
//  Enum.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/20.
//

import Foundation

enum ContainerType: Int, CaseIterable {

    case field
    case inventory
    case thirdHand

    static var caseCount: Int {
        return self.allCases.count
    }

}

//
//  WrapType.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation

class RawTypeWrapper: Equatable {

    static func == (lhs: RawTypeWrapper, rhs: RawTypeWrapper) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    let rawValue: Int

    class var count: Int { return 0 }

    init?(rawValue: Int) {
        guard 0 <= rawValue && rawValue < type(of: self).count else { return nil }

        self.rawValue = rawValue
    }

}

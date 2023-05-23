//
//  WrapType.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/23.
//

import Foundation

protocol RawTypeWrapper {

    associatedtype RawValue

    var rawValue: RawValue { get }

    static var count: Int { get }

    init(rawValue: RawValue)

}

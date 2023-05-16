//
//  UserDefaultsController.swift
//  a month game
//
//  Created by 박정훈 on 2023/05/16.
//

import Foundation

final class UserDefaultsController {

    let userDefaults = UserDefaults.standard

    func read(forKey key: String) -> Int {
        return self.userDefaults.integer(forKey: key)
    }

    func update(_ value: Int, forKey key: String) {
        self.userDefaults.set(value, forKey: key)
    }

}

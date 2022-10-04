//
//  UserFavoriteStorage.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation

public extension UserDefaultsManager {
    func userFavoriteHelper(_ username: String, completionHandler: @escaping (_ newState: Bool) -> Void) {
        let key = UserDefaultsManager.shared.generateKeyForFavoriteUser(username)
        let isFavoriteUser = UserDefaultsManager.shared.checkIfExists(key)
        if isFavoriteUser {
            UserDefaultsManager.shared.removeData(key, completionHandler: {
                completionHandler(false)
            })
        } else {
            UserDefaultsManager.shared.setData("", key) {
                completionHandler(true)
            }
        }
    }
}

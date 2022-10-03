//
//  UserFavoriteStorage.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation

public extension UserDefaultsManager {
    func toggleFavoriteUser(_ username: String, completionHandler: @escaping (_ newState: Bool) -> Void) {
        let key = UserDefaultsManager.shared.generateKeyForFavoriteUser(username)
        let isFavoriteUser = UserDefaultsManager.shared.checkIfExists(key)
        if isFavoriteUser {
            UserDefaultsManager.shared.removeData(key, completionHandler: {
                completionHandler(false)
            })
        }
        else{
            let dummyUserData: UserDetailsListItem = UserDetailsListItem(
                key: key,
                labelName: key,
                value: key)
            UserDefaultsManager.shared.setData(dummyUserData, key) {
                completionHandler(true)
            }
        }
    }
}

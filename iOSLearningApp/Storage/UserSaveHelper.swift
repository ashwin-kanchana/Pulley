//
//  UserSaveHelper.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation

public extension UserDefaultsManager {
    internal func userSaveHelper(
            _ username: String, _ userDetails: UserDetails?,
            completionHandler: @escaping (_ newState: Bool) -> Void) {
        let isUserSaved = UserDefaultsManager.shared.checkIfExists(username)
        if isUserSaved {
            UserDefaultsManager.shared.removeData(username, completionHandler: {
                completionHandler(false)
            })
        } else {
            guard let userDetails = userDetails else {
                return
            }
            UserDefaultsManager.shared.setData(userDetails, username) {
                completionHandler(true)
            }
        }
    }
}

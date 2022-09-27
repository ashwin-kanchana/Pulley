//
//  UserDefaultsManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 27/09/22.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init(){}
    
    func setData<T: Encodable>(_ object: T?, _ key: String?, completionHandler: @escaping () -> Void){
        guard let key = key, let object = object  else {
            return
        }
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
            completionHandler()
        } catch {
            print("\(error)")
        }
        
    }
    
    func getData(_ key: String, completionHandler: @escaping (_ userDetails: UserDetails?) -> Void){
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                completionHandler(userDetails)
            } catch {
                print("\(error)")
                completionHandler(nil)
            }
        }
    }
    
    
    func checkIfExists(_ key: String) -> Bool{
        return (UserDefaults.standard.object(forKey: key) != nil)
    }
    
    
    func removeData(_ key: String, completionHandler: @escaping () -> Void){
        UserDefaults.standard.removeObject(forKey: key)
        completionHandler()
    }
    
    func generateKeyForFavoriteUser(_ userName: String) -> String {
        return .Constants.favoriteUserDefaultsKeyPrefix.rawValue + userName
    }
    
    
    func toggleUserSave(_ username: String, _ userDetails: UserDetails?, completionHandler: @escaping (_ newState: Bool) -> Void){
        let isUserSaved = UserDefaultsManager.shared.checkIfExists(username)
        if isUserSaved {
            UserDefaultsManager.shared.removeData(username, completionHandler: {
                completionHandler(false)
            })
        }
        else{
            guard let userDetails = userDetails else {
                return
            }
            UserDefaultsManager.shared.setData(userDetails, username) {
                completionHandler(true)
            }
        }
    }
    
    func toggleFavoriteUser(_ username: String, completionHandler: @escaping (_ newState: Bool) -> Void){
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

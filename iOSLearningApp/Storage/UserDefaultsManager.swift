//
//  UserDefaultsManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 27/09/22.
//

import Foundation

public final class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    
    private init() {}
    
    public func setData<T: Encodable>(_ object: T?, _ key: String?, completionHandler: @escaping () -> Void) {
        guard let key = key, let object = object  else {
            return
        }
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: key)
            completionHandler()
        } catch {
            return
        }
    }
    
    internal func getData(_ key: String, completionHandler: @escaping (_ userDetails: UserDetails?) -> Void) {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                completionHandler(userDetails)
            } catch {
                completionHandler(nil)
            }
        }
    }
    
    public func checkIfExists(_ key: String) -> Bool {
        return (UserDefaults.standard.object(forKey: key) != nil)
    }
    
    public func removeData(_ key: String, completionHandler: @escaping () -> Void) {
        UserDefaults.standard.removeObject(forKey: key)
        completionHandler()
    }
    
    public func generateKeyForFavoriteUser(_ userName: String) -> String {
        return .Constants.favoriteUserDefaultsKeyPrefix.rawValue + userName
    }
}

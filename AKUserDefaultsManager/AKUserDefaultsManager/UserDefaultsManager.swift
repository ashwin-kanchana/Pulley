//
//  UserDefaultsManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 27/09/22.
//

import Foundation

public class UserDefaultsManager {
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
    
    public func getData<T: Codable>(_ key: String, completionHandler: @escaping (T?) -> Void) {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let userDetails = try JSONDecoder().decode(T.self, from: data)
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
        return UserDefaultKeys.Favorite.rawValue + userName
    }
}

// MARK: Favorite user enum
public enum UserDefaultKeys: String {
    case Favorite
}

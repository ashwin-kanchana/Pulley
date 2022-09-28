//
//  UserDetailsViewModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 23/09/22.
//

import Foundation



protocol UserDetailsViewModelDelegate : AnyObject {
    func showLoader(_ show : Bool)
    func loadData(_ userDetails: UserDetails, _ userDetailList: [UserDetailsListItem])
    func showError(_ errorMessage: String)
    func toggleFavorite(_ newState: Bool)
    func toggleSave(_ newState: Bool)
}


class UserDetailsViewModel {
    weak var userDetailsDelegate: UserDetailsViewModelDelegate?
    private let username: String
    
    var isUserSaved: Bool
    var isUserFavorited: Bool
    
    init(username: String) {
        self.username = username
        self.isUserSaved = UserDefaultsManager.shared.checkIfExists(username)
        self.isUserFavorited = UserDefaultsManager.shared.checkIfExists(UserDefaultsManager.shared.generateKeyForFavoriteUser(username))
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    
    func viewDidLoad(){
        userDetailsDelegate?.showLoader(true)
        if(UserDefaultsManager.shared.checkIfExists(username)){
            UserDefaultsManager.shared.getData(username) { [self]
                userDetails in
                guard let userDetails = userDetails else {
                    return
                }
                DispatchQueue.main.async {
                    self.userDetailsDelegate?.loadData(userDetails, self.makeUserDetailListFromObject(userDetails))
                    self.userDetailsDelegate?.showLoader(false)
                }
            }
        }
        else{
            let seconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.loadFromAPI()
            }
            
        }
    }
    
    func loadFromAPI(){
        NetworkManager.shared.fetchData(UserDetailsAPI(username: username)) { (userDetails: UserDetails?) in
            if let userDetails = userDetails {
                self.userDetailsDelegate?.loadData(userDetails, self.makeUserDetailListFromObject(userDetails))
                self.userDetailsDelegate?.showLoader(false)
            }
            else{
                self.userDetailsDelegate?.showLoader(false)
                self.userDetailsDelegate?.showError(.Constants.defaultErrorMessage.rawValue)
            }
        }
    }
    
    func makeUserDetailListFromObject(_ userDetails: UserDetails) -> [UserDetailsListItem] {
        var userDetailsList: [UserDetailsListItem] = []
        let mirrored_object = Mirror(reflecting: userDetails)
        for (_, attr) in mirrored_object.children.enumerated() {
            if let propertyName = attr.label as String? {
                let label = getUserDeatailLabelByKey(propertyName)
                if label != propertyName {
                    if let value = attr.value as? String {
                        let userDetailItem = UserDetailsListItem(key: label, labelName: label, value: value)
                        userDetailsList.append(userDetailItem)
                    }
                    else if let value = attr.value as? Int {
                        let userDetailItem = UserDetailsListItem(key: label, labelName: label, value: String(describing: value))
                        userDetailsList.append(userDetailItem)
                    }
                }
                
            }
        }
        return userDetailsList
    }
    
    
    func toggleSaveUser(_ username: String, _ userDetails: UserDetails?){
        UserDefaultsManager.shared.toggleUserSave(username, userDetails){ [self]
            newState in
            isUserSaved = newState
            self.userDetailsDelegate?.toggleSave(newState)
        }
    }
    
    func toggleFavoriteUser(_ username: String){
        UserDefaultsManager.shared.toggleFavoriteUser(username){
            newState in
            self.isUserFavorited = newState
            self.userDetailsDelegate?.toggleFavorite(newState)
            let notificationName = newState ? String.Constants.favoriteUserNotificationKey.rawValue :
                String.Constants.unFavoriteUserNotificationKey.rawValue
            let customData = [String.Constants.notificationDataKey.rawValue: username] 
            NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil, userInfo: customData)
        }
        
    }
    
}



struct UserDetailsAPI: API {
    
    let username: String
    
    var path: String {
        return "\(APIConstants.userDetailsPath.rawValue)\(username)"
    }
    
    var queryParams: [String : String]?
    
    var headers: [String : String]?
    
    var body: [String : String]?
    
    
}

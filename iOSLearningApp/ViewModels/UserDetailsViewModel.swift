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
}


class UserDetailsViewModel {
    
    weak var userDetailsDelegate: UserDetailsViewModelDelegate?
    private let username: String
    
    init(username: String) {
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewDidLoad(){
        userDetailsDelegate?.showLoader(true)
        loadFromAPI()
    }
    
    
    func loadFromAPI(){
        NetworkManager.shared.fetchData(UserDetailsAPI(username: username)) { (userDetails: UserDetails?) in
            if let userDetails = userDetails {
                self.userDetailsDelegate?.loadData(userDetails, self.makeUserDetailListFromObject(userDetails))
                self.userDetailsDelegate?.showLoader(false)
                
            }
            else{
                self.userDetailsDelegate?.showLoader(false)
                self.userDetailsDelegate?.showError("Something went wrong")
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

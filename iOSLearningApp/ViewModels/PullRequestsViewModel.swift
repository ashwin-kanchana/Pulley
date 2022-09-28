//
//  ViewModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation


protocol PullRequestsViewModelDelegate : AnyObject {
    func showLoader(_ show : Bool)
    func loadData()
    func showError(_ errorMessage: String)
    func toggleFavorite(_ username: String)
}




class PullRequestsViewModel {
    static let shared = PullRequestsViewModel()
    
    private init (){}
    
    weak var pullRequestsDelegate: PullRequestsViewModelDelegate?
    
    var pageNumber = 1
    var pageSize = 10
    private var initialLoad = true
    var pullRequestsList: [PullRequestTableCellItem] = []
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func createNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(addFavoriteNotification), name: Notification.Name(.Constants.favoriteUserNotificationKey.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeFavoriteNotification), name: Notification.Name(.Constants.unFavoriteUserNotificationKey.rawValue), object: nil)
    }

    
    func toggleFavorite(_ username: String){
        UserDefaultsManager.shared.toggleFavoriteUser(username) { [self]
            newState in
            
            if let row = self.pullRequestsList.firstIndex(where: {$0.user.login == username}) {
                pullRequestsList[row].user.isFavorite = newState
            }
            
            // iterating because of duplicate items in list
            pullRequestsList = refreshFavoritesStateForList(pullRequestsList, username)
            
            
            self.pullRequestsDelegate?.loadData()
        }
        
    }
    
    @objc
    func addFavoriteNotification(notification: Notification){
        let userInfo = notification.userInfo
        if let username = userInfo?[String.Constants.notificationDataKey.rawValue]  as? String{
            pullRequestsList = refreshFavoritesStateForList(pullRequestsList, username)
            self.pullRequestsDelegate?.loadData()
        }
    }
    
    @objc
    func removeFavoriteNotification(notification: Notification){
        let userInfo = notification.userInfo
        if let username = userInfo?[String.Constants.notificationDataKey.rawValue]  as? String{
            pullRequestsList = refreshFavoritesStateForList(pullRequestsList, username)
            self.pullRequestsDelegate?.loadData()
        }
    }
    
    func viewDidLoad(){
        createNotificationObservers()
        pullRequestsDelegate?.showLoader(true)
        loadFromAPI()
    }
    
    func loadNextPage(){
        pageNumber += 1
        loadFromAPI()
    }
    
    func refreshFavoritesStateForList(_ items: [PullRequestTableCellItem], _ username: String) -> [PullRequestTableCellItem]{
        
        // MARK: optimize by filtering list with target username
        var processedList: [PullRequestTableCellItem] = []
        for item in items {
            let key = UserDefaultsManager.shared.generateKeyForFavoriteUser(item.user.login)
            let isUserFavorite = UserDefaultsManager.shared.checkIfExists(key)
            let tableCellUser = TableCellUser(
                login: item.user.login,
                avatar_url: item.user.avatar_url,
                isFavorite: isUserFavorite)
            let processedItem = PullRequestTableCellItem(
                id: item.id,
                title: item.title,
                user: tableCellUser,
                body: item.body)
            processedList.append(processedItem)
        }
        return processedList
    }
    
    func preProcessFavoritesStateForList(_ items: [PullRequestItem]) -> [PullRequestTableCellItem]{
        var processedList: [PullRequestTableCellItem] = []
        for item in items {
            let key = UserDefaultsManager.shared.generateKeyForFavoriteUser(item.user.login)
            let isUserFavorite = UserDefaultsManager.shared.checkIfExists(key)
            let tableCellUser = TableCellUser(
                login: item.user.login,
                avatar_url: item.user.avatar_url,
                isFavorite: isUserFavorite)
            let processedItem = PullRequestTableCellItem(
                id: item.id,
                title: item.title,
                user: tableCellUser,
                body: item.body)
            processedList.append(processedItem)
        }
        return processedList
    }
   
    func loadFromAPI(){
        NetworkManager.shared.fetchData(PullRequestAPI(pageNumber: pageNumber, pageSize: pageSize)) { [self] (items: [PullRequestItem]?) in
            if let items = items {
                self.pullRequestsList.append(contentsOf: preProcessFavoritesStateForList(items))
                self.pullRequestsDelegate?.loadData()
                if self.initialLoad {
                    self.pullRequestsDelegate?.showLoader(false)
                    self.initialLoad = false
                }
            }
            else{
                self.pullRequestsDelegate?.showLoader(false)
                self.pullRequestsDelegate?.showError(.Constants.defaultErrorMessage.rawValue)
            }
        }
    }
    func checkFavoriteUser(_ username: String) -> Bool{
        let key = UserDefaultsManager.shared.generateKeyForFavoriteUser(username)
        return UserDefaultsManager.shared.checkIfExists(key)
    }
    
}



struct PullRequestAPI: API {
    let pageNumber: Int
    let pageSize: Int
    
    var path: String {
        return APIConstants.pullRequestsPath.rawValue
    }
    
    var queryParams: [String : String]? {
        return [APIConstants.pageQueryParam.rawValue : String(pageNumber), APIConstants.perPageQyeryParam.rawValue: String(pageSize)]
    }
    
    var headers: [String : String]?
    
    var body: [String : String]?
    
    
}

//
//  ViewModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation

// MARK: PullRequests ViewModel Delegate
protocol PullRequestsViewModelDelegate: AnyObject {
    func showLoader(_ show: Bool)
    func loadData()
}

class PullRequestsViewModel {
    weak var pullRequestsDelegate: PullRequestsViewModelDelegate?
    public var pullRequestsList: [PullRequestTableCellItem] = []
    private var initialLoad = true
    private var pageNumber = 1
    private var pageSize = 10
    
    func viewDidLoad() {
        createNotificationObservers()
        pullRequestsDelegate?.showLoader(true)
        loadFromAPI()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Public functions
    public func toggleFavorite(_ username: String) {
        UserDefaultsManager.shared.toggleFavoriteUser(username) {
            [self]
            newState in
            if let row = self.pullRequestsList.firstIndex(where: {$0.user.login == username}) {
                pullRequestsList[row].user.isFavorite = newState
            }
            // iterating because of duplicate items in list
            pullRequestsList = self.refreshFavoritesStateForList(pullRequestsList, username)
            self.pullRequestsDelegate?.loadData()
        }
    }
    
    public func loadNextPage() {
        pageNumber += 1
        loadFromAPI()
    }
    
    public func shouldLoadNextPage(_ index: Int) -> Bool {
        return index + 2 == pullRequestsList.count
    }
    
    // MARK: Objc functions
    @objc
    func addFavoriteNotification(notification: Notification) {
        let userInfo = notification.userInfo
        if let username = userInfo?[String.Constants.notificationDataKey.rawValue]  as? String{
            pullRequestsList = refreshFavoritesStateForList(pullRequestsList, username)
            self.pullRequestsDelegate?.loadData()
        }
    }
    
    @objc
    func removeFavoriteNotification(notification: Notification) {
        let userInfo = notification.userInfo
        if let username = userInfo?[String.Constants.notificationDataKey.rawValue]  as? String{
            pullRequestsList = refreshFavoritesStateForList(pullRequestsList, username)
            self.pullRequestsDelegate?.loadData()
        }
    }
    
    // MARK: Private functions
    private func createNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addFavoriteNotification),
            name: Notification.Name(.Constants.favoriteUserNotificationKey.rawValue),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeFavoriteNotification),
            name: Notification.Name(.Constants.unFavoriteUserNotificationKey.rawValue),
            object: nil
        )
    }
    
    private func refreshFavoritesStateForList(
        _ items: [PullRequestTableCellItem],
        _ username: String
    ) -> [PullRequestTableCellItem]{
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
    
    private func preProcessFavoritesStateForList(_ items: [PullRequestItem]) -> [PullRequestTableCellItem]{
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
   
    private func loadFromAPI() {
        NetworkManager.shared.fetchData(
            PullRequestAPI(pageNumber: pageNumber, pageSize: pageSize)
        ) {
            [self] (items: [PullRequestItem]?) in
            if let items = items {
                pullRequestsList.append(contentsOf: preProcessFavoritesStateForList(items))
                self.pullRequestsDelegate?.loadData()
                if self.initialLoad {
                    self.pullRequestsDelegate?.showLoader(false)
                    self.initialLoad = false
                }
            } else { self.pullRequestsDelegate?.showLoader(false) }
        }
    }
    
    private func checkFavoriteUser(_ username: String) -> Bool {
        let key = UserDefaultsManager.shared.generateKeyForFavoriteUser(username)
        return UserDefaultsManager.shared.checkIfExists(key)
    }
}

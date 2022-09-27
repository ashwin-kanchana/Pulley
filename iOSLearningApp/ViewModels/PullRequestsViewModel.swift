//
//  ViewModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation


protocol PullRequestsViewModelDelegate : AnyObject {
    func showLoader(_ show : Bool)
    func loadData(_ response: [PullRequestItem])
    func showError(_ errorMessage: String)
}


class PullRequestsViewModel {
    weak var pullRequestsDelegate: PullRequestsViewModelDelegate?
    
    var pageNumber = 1
    var pageSize = 10
    
    private var pullRequestsList: [PullRequestItem] = []

    
    func viewDidLoad(){
        pullRequestsDelegate?.showLoader(true)
        loadFromAPI()
    }
    
    func loadNextPage(){
        pageNumber += 1
        loadFromAPI()
    }
    
   
    func loadFromAPI(){
        NetworkManager.shared.fetchData(PullRequestAPI(pageNumber: pageNumber)) { (items: [PullRequestItem]?) in
            if let items = items {
                self.pullRequestsDelegate?.loadData(items)
                self.pullRequestsDelegate?.showLoader(false)
            }
            else{
                self.pullRequestsDelegate?.showLoader(false)
                self.pullRequestsDelegate?.showError("Something went wrong")
            }
        }
    }
}



struct PullRequestAPI: API {
    let pageNumber: Int
    let pageSize: Int = 10
    
    var path: String {
        return APIConstants.pullRequestsPath.rawValue
    }
    
    var queryParams: [String : String]? {
        return ["page" : String(pageNumber), "per_page": String(pageSize)]
    }
    
    var headers: [String : String]?
    
    var body: [String : String]?
    
    
}

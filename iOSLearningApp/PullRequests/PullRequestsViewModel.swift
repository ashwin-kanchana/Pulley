//
//  ViewModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation


protocol PullRequestsViewModelDelegate : AnyObject {
    func showLoader(_ show : Bool)
    func loadData(_ response: PullRequestsModel)
    func showError(_ errorMessage: String)
}


class PullRequestsViewModel {
    weak var delegate: PullRequestsViewModelDelegate?
    
    private var currentPage = 1
    private let itemsPerPage = 10
    
    

    
    func viewDidLoad(){
        delegate?.showLoader(true)
        
        
        if let response = FileManager.loadJson(filename: "sample"){
            print("response items count: \(String(describing: response.items.count))")
            delegate?.showLoader(false)
            delegate?.loadData(response)
        }
        else{
            delegate?.showLoader(false)
            delegate?.showError("Something went wrong!")
        }
        
        
    }
    
    
    private func getPullRequestsFromApi(){
        let url = URL(string: "\(APIConstants.pullRequestsURL.rawValue)\(APIConstants.pageQueryParam.rawValue)\(currentPage)\(APIConstants.perPageQyeryParam)\(itemsPerPage)")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
}

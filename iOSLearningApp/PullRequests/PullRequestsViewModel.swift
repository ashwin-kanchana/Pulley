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
    
    private var currentPage = 1
    private var itemsPerPage = 10
    
    private var pullRequestsList: PullRequestsModel!

    
    func viewDidLoad(){
        pullRequestsDelegate?.showLoader(true)
        loadFromAPI()
    }
    
    func loadNextPage(){
        currentPage += 1
        
    }
    
    
    func loadFromAPI(){
        let url = "\(APIConstants.pullRequestsURL.rawValue)\(APIConstants.pageQueryParam.rawValue)\(currentPage)\(APIConstants.perPageQyeryParam.rawValue)\(itemsPerPage)"

        guard let url = URL(string: url) else{
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, res, err) in

            guard let data = data else {
                  return
            }

            do {
                print(data)
                let json = try JSONDecoder().decode([PullRequestItem].self, from: data)
                print(json)
                //self.pullRequestsList = json
                print("data loaded from api in viewModel")
                DispatchQueue.main.async {
                    self.pullRequestsDelegate?.loadData(json)
                    self.pullRequestsDelegate?.showLoader(false)
                }
                
            } catch {
                print("network Error info: \(error)")
                DispatchQueue.main.async {
                    self.pullRequestsDelegate?.showLoader(false)
                    self.pullRequestsDelegate?.showError("Something went wrong!")
                }
                
            }

        }.resume()
    }
}

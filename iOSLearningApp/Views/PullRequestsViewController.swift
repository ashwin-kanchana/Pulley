//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Nveen Bandlamudi on 09/06/22.
//

import UIKit
import SnapKit

class PullRequestsViewController: UIViewController {
    
    private let screenHeadingLabel = UILabel()
    private let pullRequestTableView = UITableView()
    private let loadingContainerView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    //private var pullRequestsList: [PullRequestTableCellItem] = []
    private var showBottomLoader: Bool = false
    private let pullRequestViewModel = PullRequestsViewModel.shared
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
        
//        MARK: testing shortcut for 2nd screen
//        let userDetailsView = UserDetailsView(username: "al45tair")
//        self.navigationController?.pushViewController(userDetailsView,animated:true)
        
        
        pullRequestViewModel.pullRequestsDelegate = self
        pullRequestViewModel.viewDidLoad()
        setupHeadingLabel()
    }
    
    func setupHeadingLabel(){
        screenHeadingLabel.text  = .Constants.pullRequest.rawValue
        screenHeadingLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        view.addSubview(screenHeadingLabel)
        screenHeadingLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(10)
            
        }
    }
    
    
    func showLoadingIndicator(){
        view.addSubview(loadingContainerView)
        loadingContainerView.backgroundColor = .white
        loadingContainerView.snp.makeConstraints{
            make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        loadingContainerView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints{
            make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
    }
    
    func stopLoadindIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
}



extension PullRequestsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequestViewModel.pullRequestsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCell(withIdentifier: .Constants.pullRequestsCellIdentifier.rawValue) as! PullRequestsTableViewCell
        let item = pullRequestViewModel.pullRequestsList[indexPath.row]
        //dataCell.delegate = self
        dataCell.setPullRequestTableCellData(item: item)
        return dataCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsView = UserDetailsViewController(username: pullRequestViewModel.pullRequestsList[indexPath.row].user.login)
        self.navigationController?.pushViewController(userDetailsView,animated:true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row + 2 == pullRequestViewModel.pullRequestsList.count){
            pullRequestViewModel.loadNextPage()
        }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                let spinner = UIActivityIndicatorView()
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

                self.pullRequestTableView.tableFooterView = spinner
                self.pullRequestTableView.tableFooterView?.isHidden = false
        }
    }
    
}




extension PullRequestsViewController : PullRequestsViewModelDelegate {
    
    func showLoader(_ show: Bool) {
        if(show){
            showLoadingIndicator()
        }
        else{
            stopLoadindIndicator()
            self.view.addSubview(self.pullRequestTableView)
            self.pullRequestTableView.separatorColor = UIColor.clear
            self.pullRequestTableView.dataSource = self
            self.pullRequestTableView.delegate = self
            self.pullRequestTableView.register(PullRequestsTableViewCell.self, forCellReuseIdentifier: .Constants.pullRequestsCellIdentifier.rawValue)
            self.pullRequestTableView.snp.makeConstraints{
                make in
                make.top.equalTo(self.screenHeadingLabel.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    func loadData() {
        pullRequestTableView.reloadData()
    }
    
    func showError(_ errorMessage: String) {
        stopLoadindIndicator()
        let alert = UIAlertController(title: "Error",
                                      message: errorMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(
            UIAlertAction(title: "Dismiss",
                          style: UIAlertAction.Style.default) {
                              (result: UIAlertAction) -> Void in
                          })
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func toggleFavorite(_ username: String) {
        
    }
}

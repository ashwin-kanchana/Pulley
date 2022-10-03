//
//  ViewController.swift
//  iOSLearningApp
//
//  Created by Nveen Bandlamudi on 09/06/22.
//

import UIKit
import SnapKit

class PullRequestsViewController: UIViewController {
    private let pullRequestsContainerView = UIView()
    private let screenHeadingLabel = UILabel()
    private let pullRequestTableView = UITableView()
    private let loadingView = LoadingView()
    private let pullRequestViewModel = PullRequestsViewModel()
    private var showBottomLoader: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pullRequestViewModel.pullRequestsDelegate = self
        pullRequestViewModel.viewDidLoad()
        setUpNavigationBar()
        setupHeadingLabel()
    }
    
    private func setUpNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func setupHeadingLabel() {
        view.addSubview(pullRequestsContainerView)
        view.backgroundColor = .white
        
        screenHeadingLabel.text  = .Constants.pullRequest.rawValue
        screenHeadingLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(FloatConstants.pt22.rawValue))
        
        pullRequestsContainerView.backgroundColor = .white
        pullRequestsContainerView.snp.makeConstraints {
            make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        pullRequestsContainerView.addSubview(screenHeadingLabel)
        screenHeadingLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(IntConstants.ptN30.rawValue)
            make.leading.equalToSuperview().offset(IntConstants.pt16.rawValue)
        }
    }
}



// MARK: PullRequestsViewController TavleView methods
extension PullRequestsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequestViewModel.pullRequestsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCell(
            withIdentifier: .Constants.pullRequestsCellIdentifier.rawValue
        ) as! PullRequestsTableViewCell
        let item = pullRequestViewModel.pullRequestsList[indexPath.row]
        dataCell.setPullRequestTableCellData(item: item, pullRequestViewModel: pullRequestViewModel)
        return dataCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailsView = UserDetailsViewController(username: pullRequestViewModel.pullRequestsList[indexPath.row].user.login)
        self.navigationController?.pushViewController(userDetailsView,animated:true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if pullRequestViewModel.shouldLoadNextPage(indexPath.row) {
            pullRequestViewModel.loadNextPage()
        }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                let spinner = UIActivityIndicatorView()
                spinner.startAnimating()
                spinner.frame = CGRect(
                    x: CGFloat(FloatConstants.pt0.rawValue),
                    y: CGFloat(FloatConstants.pt0.rawValue),
                    width: tableView.bounds.width,
                    height: CGFloat(FloatConstants.pt44.rawValue)
                )
                self.pullRequestTableView.tableFooterView = spinner
                self.pullRequestTableView.tableFooterView?.isHidden = false
        }
    }
    
}



// MARK: PullRequests ViewModel integration
extension PullRequestsViewController : PullRequestsViewModelDelegate {
    
    func showLoader(_ show: Bool) {
        if show {
            pullRequestsContainerView.addSubview(loadingView)
        }
        else {
            DispatchQueue.main.async {
                [self] in
                loadingView.removeFromSuperview()
                pullRequestsContainerView.addSubview(pullRequestTableView)
                pullRequestTableView.separatorColor = UIColor.clear
                pullRequestTableView.dataSource = self
                pullRequestTableView.delegate = self
                pullRequestTableView.register(PullRequestsTableViewCell.self, forCellReuseIdentifier: .Constants.pullRequestsCellIdentifier.rawValue)
                pullRequestTableView.snp.makeConstraints{
                    make in
                    make.top.equalTo(screenHeadingLabel.snp.bottom)
                    make.leading.trailing.bottom.equalToSuperview()
                }
            }
        }
    }
    
    func loadData() {
        pullRequestTableView.reloadData()
    }
    
    func showError(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func toggleFavorite(_ username: String) {
        print(username)
    }
}

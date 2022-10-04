//
//  UserDetailsView.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation
import UIKit
import SnapKit

class UserDetailsViewController: UIViewController {
    private let userDetailsViewModel: UserDetailsViewModel
    private let username: String
    private let userDetailsView = UIView()
    private let userDetailsStickyHeader = UserDetailsHeaderView()
    private let userDetailsTableView = UITableView()
    private let loadingView = LoadingView()
    private var userDetails: UserDetails?
    private var userDetailsList: [UserDetailsListItem] = []
    private var navSaveButton = UIBarButtonItem()
    private var navFavoriteButton = UIBarButtonItem()
    
    init(username: String) {
        self.username = username
        self.userDetails = nil
        self.userDetailsViewModel = UserDetailsViewModel(username: username)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailsViewModel.userDetailsDelegate = self
        userDetailsViewModel.viewDidLoad()
        configureAllViews()
    }
    
    private func configureAllViews() {
        self.view.addSubview(userDetailsView)
        userDetailsView.snp.makeConstraints{
            make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        userDetailsView.backgroundColor = .white
    }
    
    private func configureNavigationBarButttons() {
        navSaveButton.action = #selector(toggleSaveUserDetails)
        navSaveButton.image = userDetailsViewModel.isUserSaved ? .Assets.unsave.image : .Assets.save.image
        navSaveButton.target = self
        navFavoriteButton.action = #selector(toggleFavoriteUser)
        navFavoriteButton.image = userDetailsViewModel.isUserFavorited ? .Assets.unfav.image : .Assets.fav.image
        navFavoriteButton.target = self
        navigationItem.rightBarButtonItems = [ navSaveButton, navFavoriteButton ]
    }
    
    @objc
    private func toggleSaveUserDetails() {
        if userDetailsViewModel.isUserSaved {
            let confirmationAlert = UIAlertController(
                title: .Constants.unSaveConfirmationMessage.rawValue,
                message: .Constants.areYouSureMessage.rawValue,
                preferredStyle: UIAlertController.Style.alert
            )
            
            confirmationAlert.addAction(UIAlertAction(
                title: .Constants.confirmAction.rawValue,
                style: .destructive,
                handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async { [self] in
                    userDetailsViewModel.toggleSaveUser(username, self.userDetails)
                }
            }))
            
            confirmationAlert.addAction(UIAlertAction(
                title: .Constants.cancelAction.rawValue,
                style: .cancel,
                handler: { (action: UIAlertAction!) in
                  //do nothing
            }))
            
            present(confirmationAlert, animated: true, completion: nil)
        } else {
            userDetailsViewModel.toggleSaveUser(username, userDetails)
        }
    }
    
    @objc
    private func toggleFavoriteUser() {
        if userDetailsViewModel.isUserFavorited {
            let confirmationAlert = UIAlertController(
                title: .Constants.unFavoriteConfirmationMessage.rawValue,
                message: .Constants.areYouSureMessage.rawValue,
                preferredStyle: UIAlertController.Style.alert
            )
            confirmationAlert.addAction(UIAlertAction(
                title: .Constants.confirmAction.rawValue,
                style: .destructive,
                handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async { [self] in
                    self.userDetailsViewModel.toggleFavoriteUser(username)
                }
            }))
            confirmationAlert.addAction(UIAlertAction(
                title: .Constants.cancelAction.rawValue,
                style: .cancel,
                handler: { (action: UIAlertAction!) in
                  //do nothing
            }))
            present(confirmationAlert, animated: true, completion: nil)
        } else {
            userDetailsViewModel.toggleFavoriteUser(username)
        }
    }
    
    private func updateFavoriteToggleIcon() {
        self.navFavoriteButton.image = userDetailsViewModel.isUserFavorited ? .Assets.unfav.image : .Assets.fav.image
    }
    
    private func updateSaveToggleIcon() {
        self.navSaveButton.image = userDetailsViewModel.isUserSaved ? .Assets.unsave.image : .Assets.save.image
    }
    
}


extension UserDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: .Constants.userDetailsCellIdentifier.rawValue,
            for: indexPath
        ) as? UserDetailsTableViewCell else {
            return UserDetailsTableViewCell()
        }
        let item = userDetailsList[indexPath.row]
        cell.setUserDetailsTableCellData(item)
        return cell
    }
}

// MARK: UserDetails ViewModel Delegate functions
extension UserDetailsViewController : UserDetailsViewModelDelegate {
    func toggleFavorite(_ newState: Bool) {
        updateFavoriteToggleIcon()
    }
    
    func toggleSave(_ newState: Bool) {
        updateSaveToggleIcon()
    }
    
    func showLoader(_ show: Bool) {
        if show {
            userDetailsView.addSubview(loadingView)
        } else {
            DispatchQueue.main.async {
                [self] in
                loadingView.removeFromSuperview()
                userDetailsView.addSubview(userDetailsStickyHeader)
                userDetailsStickyHeader.snp.makeConstraints{
                    make in
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    make.leading.trailing.equalToSuperview()
                    
                }
                userDetailsView.addSubview(self.userDetailsTableView)
                self.userDetailsTableView.separatorColor = UIColor.clear
                self.userDetailsTableView.dataSource = self
                self.userDetailsTableView.register(
                    UserDetailsTableViewCell.self,
                    forCellReuseIdentifier: .Constants.userDetailsCellIdentifier.rawValue
                )
                self.userDetailsTableView.snp.makeConstraints{
                    make in
                    make.top.equalTo(self.userDetailsStickyHeader.snp.bottom)
                    make.leading.trailing.bottom.equalToSuperview()
                }
            }
            
        }
    }
    
    func loadData(_ userDetails: UserDetails, _ userDetailsList: [UserDetailsListItem]) {
        self.userDetailsList = userDetailsList
        self.userDetails = userDetails
        setData()
    }
    
    func showError(_ errorMessage: String) {
        //do nothing
    }
    
    func setData() {
        guard let userDetails = userDetails else {
            return
        }
        configureNavigationBarButttons()
        userDetailsStickyHeader.setData(userDetails)
    }
}

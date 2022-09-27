//
//  UserDetailsView.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation
import UIKit
import SnapKit

//class UserDetailsHeaderView: UIView {
//    
//}

class UserDetailsViewController: UIViewController {
    
    private let userDetailsViewModel: UserDetailsViewModel
    private let username: String
    private let userDetailsView = UIView()
    private let usernameLabel = UILabel()
    private let nameLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let followersHelperLabel = UILabel()
    private let followingHelperLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let userDetailsTableView = UITableView()
    private let loadingContainerView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
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
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetailsViewModel.userDetailsDelegate = self
        userDetailsViewModel.viewDidLoad()
        configureAllViews()
    }
    
    
    
    private func configureAllViews(){
        configureUserDetailsView()
        configureAvatarImageView()
        configureNameLabel()
        configureUsernameLabel()
        configureFollowersLabel()
        configureFollowingLabel()
    }
    
    private func configureNavigationBarButttons(){
        navSaveButton.action = #selector(toggleSaveUserDetails)
        navSaveButton.image = userDetailsViewModel.isUserSaved ? .Assets.unsave.image : .Assets.save.image
        navSaveButton.target = self
        navFavoriteButton.action = #selector(toggleFavoriteUser)
        navFavoriteButton.image = userDetailsViewModel.isUserFavorited ? .Assets.unfav.image : .Assets.fav.image
        navFavoriteButton.target = self
        navigationItem.rightBarButtonItems = [ navSaveButton, navFavoriteButton ]
    }
    
    
    @objc private func toggleSaveUserDetails(){
        if(userDetailsViewModel.isUserSaved){
            let confirmationAlert = UIAlertController(title: .Constants.unSaveConfirmationMessage.rawValue, message: .Constants.areYouSureMessage.rawValue, preferredStyle: UIAlertController.Style.alert)
            confirmationAlert.addAction(UIAlertAction(title: .Constants.confirmAction.rawValue, style: .destructive, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async { [self] in
                    userDetailsViewModel.toggleSaveUser(username, self.userDetails)
                }
            }))
            confirmationAlert.addAction(UIAlertAction(title: .Constants.cancelAction.rawValue, style: .cancel, handler: { (action: UIAlertAction!) in
                  //do nothing
            }))
            present(confirmationAlert, animated: true, completion: nil)
        }
        else{
            userDetailsViewModel.toggleSaveUser(username, userDetails)
        }
    }
    
    @objc private func toggleFavoriteUser(){
        if(userDetailsViewModel.isUserFavorited){
            let confirmationAlert = UIAlertController(title: .Constants.unFavoriteConfirmationMessage.rawValue, message: .Constants.areYouSureMessage.rawValue, preferredStyle: UIAlertController.Style.alert)
            confirmationAlert.addAction(UIAlertAction(title: .Constants.confirmAction.rawValue, style: .destructive, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async { [self] in
                    self.userDetailsViewModel.toggleFavoriteUser(username)
                }
            }))
            confirmationAlert.addAction(UIAlertAction(title: .Constants.cancelAction.rawValue, style: .cancel, handler: { (action: UIAlertAction!) in
                  //do nothing
            }))
            present(confirmationAlert, animated: true, completion: nil)
        }
        else{
            userDetailsViewModel.toggleFavoriteUser(username)
        }
    }
    
    private func updateFavoriteToggleIcon(){
        self.navFavoriteButton.image = userDetailsViewModel.isUserFavorited ? .Assets.unfav.image : .Assets.fav.image
    }
    
    private func updateSaveToggleIcon(){
        self.navSaveButton.image = userDetailsViewModel.isUserSaved ? .Assets.unsave.image : .Assets.save.image
    }
    
    private func configureUserDetailsView(){
        self.view.addSubview(userDetailsView)
        userDetailsView.backgroundColor = .white
        userDetailsView.snp.makeConstraints{
            make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureAvatarImageView(){
        userDetailsView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 70
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints{
            make in
            make.height.width.equalTo(140)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    
    private func configureNameLabel(){
        userDetailsView.addSubview(nameLabel)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        nameLabel.snp.makeConstraints{
            make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
    }
    
    
    private func configureUsernameLabel(){
        userDetailsView.addSubview(usernameLabel)
        usernameLabel.font = UIFont.systemFont(ofSize: 16.0)
        usernameLabel.textColor = .systemBlue
        usernameLabel.snp.makeConstraints{
            make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
    }
    
    
    private func configureFollowersLabel(){
        userDetailsView.addSubview(followersLabel)
        userDetailsView.addSubview(followersHelperLabel)
        followersHelperLabel.isHidden = true
        followersHelperLabel.text = .Constants.followersHelperLabelValue.rawValue
        followersHelperLabel.font = UIFont.systemFont(ofSize: 12.0)
        followersLabel.snp.makeConstraints{
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
        followersHelperLabel.snp.makeConstraints{
            make in
            make.top.equalTo(followersLabel.snp.bottom)
            make.leading.equalTo(followersLabel.snp.leading)
        }
    }
    
    private func configureFollowingLabel(){
        userDetailsView.addSubview(followingLabel)
        userDetailsView.addSubview(followingHelperLabel)
        followingHelperLabel.isHidden = true
        followingHelperLabel.text = .Constants.followingHelperLabelValue.rawValue
        followingHelperLabel.font = UIFont.systemFont(ofSize: 12.0)
        followingLabel.snp.makeConstraints{
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.trailing.equalTo(followersLabel.snp.trailing).offset(80)
        }
        followingHelperLabel.snp.makeConstraints{
            make in
            make.top.equalTo(followingLabel.snp.bottom)
            make.leading.equalTo(followingLabel.snp.leading)
        }
    }
    
    func showLoadingIndicator(){
        userDetailsView.addSubview(loadingContainerView)
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


extension UserDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .Constants.userDetailsCellIdentifier.rawValue) as! UserDetailsTableViewCell
        let item = userDetailsList[indexPath.row]
        cell.setUserDetailsTableCellData(item)
        return cell
    }
    
    
}


class UserDetailsTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewsInCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewsInCell(){
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints{
            make in
            make.leading.trailing.top.bottom.equalToSuperview().offset(20)
        }
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints{
            make in
            make.leading.top.equalToSuperview().offset(4)
        }
        containerView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    func setUserDetailsTableCellData(_ userDetailItem: UserDetailsListItem){
        descriptionLabel.text = userDetailItem.labelName
        valueLabel.text = userDetailItem.value
    }

    
}



extension UserDetailsViewController : UserDetailsViewModelDelegate {
    func toggleFavorite(_ newState: Bool) {
        updateFavoriteToggleIcon()
    }
    
    func toggleSave(_ newState: Bool) {
        updateSaveToggleIcon()
    }
    
    func showLoader(_ show: Bool) {
        if(show){
            showLoadingIndicator()
        }
        else{
            stopLoadindIndicator()
            userDetailsView.addSubview(self.userDetailsTableView)
            self.userDetailsTableView.separatorColor = UIColor.clear
            self.userDetailsTableView.dataSource = self
            self.userDetailsTableView.register(UserDetailsTableViewCell.self, forCellReuseIdentifier: .Constants.userDetailsCellIdentifier.rawValue)
            self.userDetailsTableView.snp.makeConstraints{
                make in
                make.top.equalTo(self.avatarImageView.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    func loadData(_ userDetails: UserDetails, _ userDetailsList: [UserDetailsListItem]) {
        self.userDetailsList = userDetailsList
        self.userDetails = userDetails
        setData()
        
    }
    
    func showError(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func setData() {
        guard let userDetails = userDetails else {
            return
        }
        nameLabel.text = userDetails.name
        usernameLabel.text = "@\(userDetails.login)"
        followingLabel.text = String(userDetails.following)
        followersLabel.text = String(userDetails.followers)
        followingHelperLabel.isHidden = false
        followersHelperLabel.isHidden = false
        configureNavigationBarButttons()
        NetworkManager.shared.fetchImage(userDetails.avatar_url) { image in
            DispatchQueue.main.async { [self] in
                avatarImageView.image = image
            }
        }
    }
    
    
}

//
//  UserDetailsHeaderView.swift
//  Pulley
//
//  Created by Ashwin K on 28/09/22.
//

import UIKit
import SnapKit
import Foundation

class UserDetailsHeaderView: UIView {
    private let headerContainer = UIView()
    private let usernameLabel = UILabel()
    private let nameLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let followersHelperLabel = UILabel()
    private let followingHelperLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        configureAllViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    private func configureAllViews(){
        self.addSubview(headerContainer)
        headerContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        configureAvatarImageView()
        configureNameLabel()
        configureUsernameLabel()
        configureFollowersLabel()
        configureFollowingLabel()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        self.snp.makeConstraints { make in
            make.height.width.equalTo(140)
        }
    }
    

    private func configureAvatarImageView(){
        headerContainer.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 70
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints{
            make in
            make.height.width.equalTo(140)
            make.top.equalTo(headerContainer.snp.top)
            make.bottom.equalTo(headerContainer.snp.bottom)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    
    private func configureNameLabel(){
        headerContainer.addSubview(nameLabel)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        nameLabel.snp.makeConstraints{
            make in
            make.top.equalTo(headerContainer.snp.top).offset(20)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
    }
    
    
    private func configureUsernameLabel(){
        headerContainer.addSubview(usernameLabel)
        usernameLabel.font = UIFont.systemFont(ofSize: 16.0)
        usernameLabel.textColor = .systemBlue
        usernameLabel.snp.makeConstraints{
            make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(20)
        }
    }
    
    
    private func configureFollowersLabel(){
        headerContainer.addSubview(followersLabel)
        headerContainer.addSubview(followersHelperLabel)
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
        headerContainer.addSubview(followingLabel)
        headerContainer.addSubview(followingHelperLabel)
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
    
    func setData(_ userDetails: UserDetails) {
        nameLabel.text = userDetails.name
        usernameLabel.text = "@\(userDetails.login)"
        followingLabel.text = String(userDetails.following)
        followersLabel.text = String(userDetails.followers)
        followingHelperLabel.isHidden = false
        followersHelperLabel.isHidden = false
        NetworkManager.shared.fetchImage(userDetails.avatar_url) { image in
            DispatchQueue.main.async { [self] in
                avatarImageView.image = image
            }
        }
    }

}

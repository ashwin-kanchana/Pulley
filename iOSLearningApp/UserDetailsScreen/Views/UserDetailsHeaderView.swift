//
//  UserDetailsHeaderView.swift
//  Pulley
//
//  Created by Ashwin K on 28/09/22.
//

import Foundation
import UIKit
import SnapKit
import AKNetworkManager

class UserDetailsHeaderView: UIView {
    // MARK: Private properties
    private let headerContainer = UIView()
    private let usernameLabel = UILabel()
    private let nameLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let followersHelperLabel = UILabel()
    private let followingHelperLabel = UILabel()
    private let avatarImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAllViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    private func configureAllViews() {
        self.addSubview(headerContainer)
        headerContainer.snp.makeConstraints {
            make in
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
        self.snp.makeConstraints {
            make in
            make.height.width.equalTo(IntConstants.pt140.rawValue)
        }
    }
    
    private func configureAvatarImageView() {
        headerContainer.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = CGFloat(IntConstants.pt70.rawValue)
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints {
            make in
            make.height.width.equalTo(IntConstants.pt140.rawValue)
            make.top.equalTo(headerContainer.snp.top)
            make.bottom.equalTo(headerContainer.snp.bottom)
            make.leading.equalToSuperview().offset(IntConstants.pt10.rawValue)
        }
    }
    
    private func configureNameLabel() {
        headerContainer.addSubview(nameLabel)
        nameLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(FloatConstants.pt20.rawValue))
        nameLabel.snp.makeConstraints{
            make in
            make.top.equalTo(headerContainer.snp.top).offset(IntConstants.pt20.rawValue)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(IntConstants.pt20.rawValue)
        }
    }
    
    private func configureUsernameLabel() {
        headerContainer.addSubview(usernameLabel)
        usernameLabel.font = UIFont.systemFont(ofSize: CGFloat(FloatConstants.pt16.rawValue))
        usernameLabel.textColor = .systemBlue
        usernameLabel.snp.makeConstraints{
            make in
            make.top.equalTo(nameLabel.snp.bottom).offset(IntConstants.pt5.rawValue)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(IntConstants.pt20.rawValue)
        }
    }
    
    private func configureFollowersLabel() {
        headerContainer.addSubview(followersLabel)
        headerContainer.addSubview(followersHelperLabel)
        followersHelperLabel.isHidden = true
        followersHelperLabel.text = .Constants.followersHelperLabelValue.rawValue
        followersHelperLabel.font = UIFont.systemFont(ofSize: CGFloat(FloatConstants.pt12.rawValue))
        followersLabel.snp.makeConstraints{
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(IntConstants.pt10.rawValue)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(IntConstants.pt20.rawValue)
        }
        followersHelperLabel.snp.makeConstraints{
            make in
            make.top.equalTo(followersLabel.snp.bottom)
            make.leading.equalTo(followersLabel.snp.leading)
        }
    }
    
    
    private func configureFollowingLabel() {
        headerContainer.addSubview(followingLabel)
        headerContainer.addSubview(followingHelperLabel)
        followingHelperLabel.isHidden = true
        followingHelperLabel.text = .Constants.followingHelperLabelValue.rawValue
        followingHelperLabel.font = UIFont.systemFont(ofSize: CGFloat(FloatConstants.pt12.rawValue))
        followingLabel.snp.makeConstraints{
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(IntConstants.pt10.rawValue)
            make.trailing.equalTo(followersLabel.snp.trailing).offset(IntConstants.pt80.rawValue)
        }
        
        followingHelperLabel.snp.makeConstraints{
            make in
            make.top.equalTo(followingLabel.snp.bottom)
            make.leading.equalTo(followingLabel.snp.leading)
        }
    }
    
    // MARK: Public method
    public func setData(_ userDetails: UserDetails) {
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

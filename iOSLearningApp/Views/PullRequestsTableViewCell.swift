//
//  PullRequestsTableViewCell.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 27/09/22.
//

import Foundation
import UIKit
import SnapKit




class PullRequestsTableViewCell : UITableViewCell {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let favoriteToggleButton = UIButton()
    private var favoriteClickedUsername: String?
    private let pullRequestViewModel = PullRequestsViewModel.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewsInCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViewsInCell(){
        setupContainerView()
        setupAvatarImageView()
        setupTitleLabelView()
        setupFavoriteToggleButton()
        setupSubTitleLabelView()
        setupBodyLabelView()
    }
    
    private func setupContainerView(){
        self.contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
        containerView.snp.makeConstraints{
            make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func setupAvatarImageView(){
        containerView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        avatarImageView.snp.makeConstraints{
            make in
            make.leading.top.equalToSuperview().offset(10)
            make.height.width.equalTo(70)
            make.bottom.lessThanOrEqualToSuperview().offset(-12).priority(.required)
            // make.centerY.equalToSuperview()
        }
    }
    
    
    private func setupTitleLabelView(){
        containerView.addSubview(titleLabel)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.snp.makeConstraints{
            make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
        }
    }
    
    private func setupSubTitleLabelView(){
        containerView.addSubview(subTitleLabel)
        subTitleLabel.textColor = .black
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = subTitleLabel.font.withSize(14)
        subTitleLabel.snp.makeConstraints{
            make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteToggleButton.snp.leading).offset(-8)
            //make.bottom.equalToSuperview().offset(-10).priority(.low)
        }
    }
    
    private func setupFavoriteToggleButton(){
        containerView.addSubview(favoriteToggleButton)
        favoriteToggleButton.snp.makeConstraints{
            make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        favoriteToggleButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        
    }
    
    private func setupBodyLabelView(){
        containerView.addSubview(bodyLabel)
        bodyLabel.textColor = .darkGray
        bodyLabel.numberOfLines = 0
        bodyLabel.font = bodyLabel.font.withSize(14)
        bodyLabel.snp.makeConstraints{
            make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.equalTo(favoriteToggleButton.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-10).priority(.low)
            
        }
        
    }
    
    @objc
    func toggleFavoriteUser(){
        guard let favoriteClickedUsername = favoriteClickedUsername else {
            return
        }
        pullRequestViewModel.toggleFavorite(favoriteClickedUsername)
    }
    
    func setPullRequestTableCellData(item: PullRequestTableCellItem){
        titleLabel.text = item.user.login
        subTitleLabel.text = item.title
        bodyLabel.text = item.body
        avatarImageView.image = UIImage(named: item.user.login)
        let icon = item.user.isFavorite ? UIImage.Assets.unfav.image : UIImage.Assets.fav.image
        favoriteToggleButton.setImage(icon, for: .normal)
        NetworkManager.shared.fetchImage(item.user.avatar_url) { image in
            DispatchQueue.main.async(execute: { () -> Void in
                self.avatarImageView.image = image
            })
        }
        self.favoriteClickedUsername = item.user.login
        favoriteToggleButton.addTarget(self, action: #selector(toggleFavoriteUser), for: .touchUpInside)
    }
}


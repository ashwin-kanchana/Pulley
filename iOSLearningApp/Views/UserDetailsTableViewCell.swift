//
//  UserDetailsTableViewCell.swift
//  Pulley
//
//  Created by Ashwin K on 28/09/22.
//

import UIKit
import SnapKit
import Foundation


class UserDetailsTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewsInCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
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
    
    func setToggle() {
        
    }

    
}

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
    // MARK: Private properties
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupViewsInCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    func setupViewsInCell() {
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            make in
            make.leading.trailing.top.bottom.equalToSuperview().offset(IntConstants.pt20.rawValue)
        }
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            make in
            make.leading.top.equalToSuperview().offset(IntConstants.pt4.rawValue)
        }
        containerView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(IntConstants.pt4.rawValue)
            make.trailing.equalToSuperview().offset(IntConstants.ptN40.rawValue)
        }
    }
    
    func setUserDetailsTableCellData(_ userDetailItem: UserDetailsListItem) {
        descriptionLabel.text = userDetailItem.labelName
        valueLabel.text = userDetailItem.value
    }
}

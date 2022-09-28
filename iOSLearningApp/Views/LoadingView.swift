//
//  LoadingView.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 27/09/22.
//

import Foundation
import UIKit
import SnapKit


class LoadingView: UIView {
    private let loadingContainer: UIView
    private let activityIndicator = UIActivityIndicatorView()
    
    
    override init(frame : CGRect) {
        loadingContainer = UIView(frame: frame)
        super.init(frame: frame)
        self.addSubview(loadingContainer)
        loadingContainer.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        loadingContainer.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(IntConstants.pt200.rawValue)
            make.top.equalToSuperview().offset(IntConstants.pt400.rawValue)
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
        }
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        self.snp.makeConstraints { make in
            make.height.equalTo(self.frame.size.width)
            make.width.equalTo(self.frame.size.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError(.Constants.initMissingError.rawValue)
    }
    
    

}

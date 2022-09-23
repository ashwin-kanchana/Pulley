//
//  UserDetailsViewController.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation
import UIKit
import SnapKit



class UserDetailsViewController : UIViewController {
    
    let userDetailsView = UIView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(userDetailsView)
        userDetailsView.backgroundColor = .yellow
        userDetailsView.snp.makeConstraints{
            make in
            make.height.width.equalToSuperview()
        }
    }
}

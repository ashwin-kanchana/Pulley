//
//  UserDetailsView.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation
import UIKit
import SnapKit


class UserDetailsView: UIViewController {

    
    let userDetailsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(userDetailsView)
        userDetailsView.backgroundColor = .yellow
        userDetailsView.snp.makeConstraints{
            make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

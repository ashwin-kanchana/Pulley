//
//  ImageAssetsConstants.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation
import UIKit

public extension UIImage {
    enum Assets: String {
        case save
        case unsave
        case fav
        case unfav
        
        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
}

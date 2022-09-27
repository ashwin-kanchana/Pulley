//
//  Constants.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation
import UIKit


extension String {
    
    enum Constants: String {
        case pullRequest = "Pull Requests"
        case followersHelperLabelValue = "Followers"
        case followingHelperLabelValue = "Following"
        case pullRequestsCellIdentifier = "PullRequestsCellIdentifier"
        case userDetailsCellIdentifier = "userDetailsCellIdentifier"
        case defaultErrorMessage = "Something went wrong"
        case favoriteUserNotificationKey = "favoriteUserNotificationKey"
        case unFavoriteUserNotificationKey = "unFavoriteUserNotificationKey"
        case favoriteUserDefaultsKeyPrefix = "__fav__"
        case notificationDataKey = "username"
        case newState = "newState"
    }
}

extension UIImage {
    
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



func getUserDeatailLabelByKey (_ key: String) -> String{
    switch key {
    case "company":
        return "Company"
    case "email":
        return "Email"
    case "location":
        return "Location"
    case "bio":
        return "Bio"
    case "twitter_username":
        return "Twitter"
    case "public_repos":
        return "Repositories"
    case "public_gists":
        return "Gists"
    case "created_at":
        return "Joined"
    default:
        return key
    }
}

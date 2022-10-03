//
//  Constants.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation

public func getUserDeatailLabelByKey (_ key: String) -> String{
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

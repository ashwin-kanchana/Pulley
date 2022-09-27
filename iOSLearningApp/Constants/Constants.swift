//
//  Constants.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation

enum StringConstants : String {
    case pullRequestsLabelValue = "Pull Requests"
    case pullRequestsCellIdentifier = "PullRequestsCellIdentifier"
    case loadingCellIdentifier = "loadingCellIdentifier"
    case userDetailsCellIdentifier = "userDetailsCellIdentifier"
    case sampleJsonFileName = "sample"
    case followersHelperLabelValue = "Followers"
    case followingHelperLabelValue = "Following"
    case saveAssetName = "save"
    case unsaveAssetName = "unsave"
    case favoriteAssetName = "fav"
    case unFavoriteAssetName = "unfav"
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

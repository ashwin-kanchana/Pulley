//
//  StringConstants.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation

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
        case unSaveConfirmationMessage = "Remove from storage"
        case unFavoriteConfirmationMessage = "Remove from favorites"
        case areYouSureMessage = "Are you sure?"
        case cancelAction = "Cancel"
        case confirmAction = "Confirm"
        case dismissAction = "Dismiss"
        case errorTitle = "Error"
        case initMissingError = "init(coder:) has not been implemented"
    }
}

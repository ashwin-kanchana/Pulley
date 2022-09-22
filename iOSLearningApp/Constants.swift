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
    case sampleJsonFileName = "sample"
}

enum APIConstants : String {
    case pullRequestsURL = "https://api.github.com/repos/apple/swift/pulls"
    case pageQueryParam = "?page="
    case perPageQyeryParam = "&?per_page="
}



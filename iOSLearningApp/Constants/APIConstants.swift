//
//  APIConstants.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 23/09/22.
//

import Foundation

enum APIConstants : String {
    case httpsScheme = "https"
    case baseURL = "api.github.com"
    case pullRequestsPath = "/repos/apple/swift/pulls"
    case pageQueryParam = "page"
    case perPageQyeryParam = "per_page"
    case userDetailsPath = "/users/"
}

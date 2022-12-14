//
//  PullRequestsApi.swift
//  Pulley
//
//  Created by Ashwin K on 03/10/22.
//

import Foundation
import AKNetworkManager

struct PullRequestAPI: API {
    let pageNumber: Int
    let pageSize: Int
    
    var baseUrl: String {
        return APIConstants.baseURL.rawValue
    }
    
    var path: String {
        return APIConstants.pullRequestsPath.rawValue
    }
    
    var queryParams: [String : String]? {
        return [APIConstants.pageQueryParam.rawValue : String(pageNumber),
                APIConstants.perPageQyeryParam.rawValue: String(pageSize)
        ]
    }
    
    var headers: [String : String]?
    
    var body: [String : String]?
}

//
//  UserDetailsApi.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation
import AKNetworkManager

struct UserDetailsAPI: API {
    let username: String
    
    var baseUrl: String {
        return APIConstants.baseURL.rawValue
    }
    
    var path: String {
        return "\(APIConstants.userDetailsPath.rawValue)\(username)"
    }
    
    var queryParams: [String : String]?
    
    var headers: [String : String]?
    
    var body: [String : String]?
}

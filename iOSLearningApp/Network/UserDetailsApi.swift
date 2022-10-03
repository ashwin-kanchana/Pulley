//
//  UserDetailsApi.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation

struct UserDetailsAPI: API {
    let username: String
    
    var path: String {
        return "\(APIConstants.userDetailsPath.rawValue)\(username)"
    }
    
    var queryParams: [String : String]?
    
    var headers: [String : String]?
    
    var body: [String : String]?
}

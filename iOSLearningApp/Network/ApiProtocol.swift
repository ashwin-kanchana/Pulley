//
//  ApiProtocol.swift
//  Pulley
//
//  Created by Ashwin K on 02/10/22.
//

import Foundation

// MARK: Generic API protocol
public protocol API {
    var baseUrl: String { get }
    var path: String { get }
    var queryParams: [String: String]? { get }
}

public extension API {
    var baseUrl: String {
        return APIConstants.baseURL.rawValue
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var body: [String: String]? {
        return nil
    }
}

// MARK: HTTPMethod enum
public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

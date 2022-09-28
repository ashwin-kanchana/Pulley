//
//  NetworkManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 23/09/22.
//

import Foundation
import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    
    private init (){}
    
    
    func fetchData<T:Decodable>(_ api: API, completionHandler: @escaping (T?) -> Void){
        var urlQueryItems: [URLQueryItem] = []
        if let queryParams = api.queryParams {
            queryParams.forEach{
                element in
                let urlQueryItem = URLQueryItem(name: element.key, value: element.value)
                urlQueryItems.append(urlQueryItem)
            }
        }
        var components = URLComponents()
        components.scheme = APIConstants.httpsScheme.rawValue
        components.host = api.baseUrl
        components.path = api.path
        components.queryItems = urlQueryItems
        guard let url = components.url else{
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        urlRequest.httpBody = nil
        
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(object)
                    }
                }
                catch {
                    print(error)
                }
            }
            else {
                completionHandler(nil)
            }
            
        }).resume()
    }
    
    func fetchImage(_ url: String, completionHandler: @escaping (_ image: UIImage?) ->Void){
        URLSession.shared.dataTask(with: NSURL(string: url )! as URL, completionHandler: {
            (data, response, error) -> Void in
            if let error = error {
                print(error)
            }
            let image = UIImage(data: data!)
            completionHandler(image)
        }).resume()
    }
}

protocol API {
    var baseUrl: String { get }
    var path: String { get }
    var queryParams: [String: String]? { get }
   
}

extension API {
    var baseUrl: String {
        return APIConstants.baseURL.rawValue
    }
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: [String: String]? {
        return nil
        
    }
    var body: [String: String]? { return nil }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}



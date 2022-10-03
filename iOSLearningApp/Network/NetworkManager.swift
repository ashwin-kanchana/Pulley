//
//  NetworkManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 23/09/22.
//

import Foundation
import UIKit

// MARK: Singleton NetworkManager
public final class NetworkManager {
    public static let shared = NetworkManager()
    
    private init () {} 
    
    public func fetchData<T:Decodable>(_ api: API, completionHandler: @escaping (T?) -> Void) {
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
                    completionHandler(nil)
                }
            }
            else {
                completionHandler(nil)
            }
            
        }).resume()
    }
    
    public func fetchImage(_ url: String, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        URLSession.shared.dataTask(with: NSURL(string: url )! as URL, completionHandler: {
            (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            completionHandler(image)
        }).resume()
    }
}

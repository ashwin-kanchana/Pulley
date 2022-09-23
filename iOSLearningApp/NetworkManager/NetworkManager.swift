//
//  NetworkManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 23/09/22.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    
    private init (){}
    
//    func makeRequest(url: String, completion : @escaping (Any?) -> Void ){
//        var urlRequest = URLRequest(url: URL(string: url)!)
//        urlRequest.httpMethod = "GET"
//        URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
//            if(error != nil){
//                print(error ?? "error in network manager")
//                return
//            }
//            let object = try JSONDecoder.decode(PullRequestsModel.self, data)
//            print("decoded data from api in network manager")
//            DispatchQueue.main.async {
//                //append new page to list here
//            }
//            }).resume()
//        
//    }
}

//
//  FileManager.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 21/09/22.
//

import Foundation

class FileManager {
    class func loadJson(filename fileName: String) -> PullRequestsModel? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONDecoder().decode(PullRequestsModel.self, from: data)
                return object
                //let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                if let dictionary = object as? [String: AnyObject] {
//                    return dictionary
//                }
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
        return nil
    }
    
}


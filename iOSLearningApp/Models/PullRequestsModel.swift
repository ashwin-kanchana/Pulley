//
//  SampleResponse.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 21/09/22.
//

import Foundation

struct PullRequestsModel : Decodable {
    let items : [PullRequestItem]
}

struct PullRequestItem : Decodable {
    let id : Int64
    let title : String
    let user : User
    let body : String?
}



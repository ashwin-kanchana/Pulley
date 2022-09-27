//
//  SampleResponse.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 21/09/22.
//

import Foundation

struct PullRequestsModel : Codable {
    let items : [PullRequestItem]
}

struct PullRequestItem : Codable {
    let id : Int64
    let title : String
    let user : User
    let body : String?
}

struct User : Codable {
    let id : Int64
    let type :  String
    let login:  String
    let avatar_url: String
    let html_url: String
}

struct PullRequestTableCellItem : Codable {
    let id : Int64
    let title : String
    var user : TableCellUser
    let body : String?
}

struct TableCellUser : Codable {
    let login:  String
    let avatar_url: String
    var isFavorite: Bool
}

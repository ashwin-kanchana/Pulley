//
//  PullRequestsModel.swift
//  Pulley
//
//  Created by Ashwin K on 03/10/22.
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

struct PullRequestTableCellItem : Codable {
    let id : Int64
    let title : String
    var user : TableCellUser
    let body : String?
}

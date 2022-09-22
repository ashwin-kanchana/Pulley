//
//  UserDetailsModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

import Foundation


struct User : Decodable {
    let id : Int64
    let type :  String
    let login:  String
    let avatar_url: String
    let html_url: String
}

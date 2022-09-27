//
//  UserDetailsModel.swift
//  iOSLearningApp
//
//  Created by Ashwin K on 22/09/22.
//

struct UserDetails : Decodable {
    let type :  String?
    let login:  String
    let avatar_url: String
    let name: String?
    let company: String?
    let location: String?
    let email: String?
    let bio: String?
    let twitter_username: String?
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
    let created_at: String?
}


struct UserDetailsListItem: Decodable {
    let key: String
    let labelName: String
    let value: String
}



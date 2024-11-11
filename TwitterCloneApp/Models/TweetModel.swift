//
//  TweetModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 14.10.2024.
//

import Foundation

struct TweetModel: Codable, Identifiable {
    var id = UUID().uuidString
    let author: UserModel
    let authorID: String
    let tweetText: String
    var likesCount: Int
    var likesUser: [String]
    let isReply: Bool
    let perantsReference: String?
}

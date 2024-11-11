//
//  UserModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import Foundation
import Firebase
import FirebaseAuth

struct UserModel: Codable {
    var profileImage: String = ""
    let id: String
    var displayName: String = ""
    var userName: String = ""
    var bio: String = ""
    var location: String = ""
    var link: String = ""
    var birthDate: Date = Date()
    var joinedDate: Date = Date()
    var followingCount: Int = 0
    var followersCount: Int = 0
    var isUserOnboarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
}




//
//  DatabaseManager.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestoreCombineSwift

struct DatabaseManager {

    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    let tweetsPath: String = "tweets"
    let followsPath: String = "follows"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = UserModel(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in return true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id: String) -> AnyPublisher<UserModel, Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap { try $0.data(as: UserModel.self) }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        db.collection(usersPath).document(id).updateData(updateFields)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(add tweet: TweetModel) -> AnyPublisher<Bool, Error> {
        db.collection(tweetsPath).document(tweet.id).setData(from: tweet)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(search query: String) -> AnyPublisher<[UserModel], Error> {
        db.collection(usersPath).whereField("userName", isEqualTo: query)
            .getDocuments()
            .map(\.documents)
            .tryMap { snapshots in
                try snapshots.map({
                    try $0.data(as: UserModel.self)
                })
            }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(retreive withID: String) -> AnyPublisher<[TweetModel], Error> {
        db.collection(tweetsPath).whereField("authorID", isEqualTo: withID)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map({
                    try $0.data(as: TweetModel.self)
                })
            }
            .eraseToAnyPublisher()
    }
    
    func collectionFollows(isUserFollow: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followsPath)
            .whereField("follower", isEqualTo: isUserFollow)
            .whereField("following", isEqualTo: following)
            .getDocuments()
            .tryMap(\.count)
            .map {
                $0 != 0
            }
            .eraseToAnyPublisher()
    }
    
    func collectionFollows(follower: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followsPath).document().setData([
            "follower": follower,
            "following": following
            ])
        .map { true }
        .eraseToAnyPublisher()
    }
    
    func collectionFollows(delete follower: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followsPath)
        .whereField("follower", isEqualTo: follower)
        .whereField("following", isEqualTo: following)
        .getDocuments()
        .map(\.documents.first)
        .map { query in
            query?.reference.delete(completion: nil)
            return true
        }
        .eraseToAnyPublisher()
    }
}

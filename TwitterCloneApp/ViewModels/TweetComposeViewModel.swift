//
//  TweetComposeViewViewModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import Combine
import Foundation
import FirebaseAuth

final class TweetComposeViewModel: ObservableObject {

    private var subscriptions: Set<AnyCancellable> = []
    private var user: UserModel?
    
    var tweetContent: String = ""
    
    @Published var isValidateToTweet: Bool = false
    @Published var error: String = ""
    @Published var shouldDismissCompose: Bool = false
    
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retreive: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [unowned self] userModel in
                self.user = userModel
            }
            .store(in: &subscriptions)
    }
    
    func validateToTweet() {
        isValidateToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweet() {
        guard let user = user else { return }
        let tweet = TweetModel(author: user, authorID: user.id, tweetText: tweetContent, likesCount: 0, likesUser: [], isReply: false, perantsReference: nil)
        DatabaseManager.shared.collectionTweets(add: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissCompose = state
            }
            .store(in: &subscriptions)
    }
}

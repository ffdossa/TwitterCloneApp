//
//  ProfileViewViewModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import Foundation
import Combine
import FirebaseAuth

enum ProfileFollowsState {
    case userIsFollow
    case userIsUnfollow
    case userCurrentPerson
}

final class ProfileViewModel: ObservableObject {
    
    @Published var user: UserModel
    @Published var error: String?
    @Published var tweets: [TweetModel] = []
    @Published var currentFollowsState: ProfileFollowsState = .userCurrentPerson
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(user: UserModel) {
        self.user = user
        checkIfFollowingUser()
    }
    
    func fetchUserTweets() {
        DatabaseManager.shared.collectionTweets(retreive: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] tweets in
                self?.tweets = tweets
            }
            .store(in: &subscriptions)
    }
    
    func getFormattedDate(from date: Date) -> String {
        let dateForamatter = DateFormatter()
        dateForamatter.dateFormat = "MMMM y"
        return dateForamatter.string(from: date)
    }
    
    func followingUser() {
        guard let personalUserID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionFollows(follower: personalUserID,
                                                 following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                self?.currentFollowsState = .userIsFollow
            }
            .store(in: &subscriptions)
    }
    
    func unfollowUser() {
        guard let personalUserID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionFollows(delete: personalUserID,
                                                 following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] follower in
                self?.currentFollowsState = .userIsUnfollow
            }
            .store(in: &subscriptions)
    }
    
    private func checkIfFollowingUser() {
        guard let personalUserID = Auth.auth().currentUser?.uid,
        personalUserID != user.id
        else {
            currentFollowsState = .userCurrentPerson
            return }
        DatabaseManager.shared.collectionFollows(isUserFollow: personalUserID,
                                                 following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isFollow in
                self?.currentFollowsState = isFollow ? .userIsFollow : .userIsUnfollow
            }
            .store(in: &subscriptions)
    }
}

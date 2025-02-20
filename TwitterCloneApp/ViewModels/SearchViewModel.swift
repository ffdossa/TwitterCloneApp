//
//  SearchViewViewModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import Foundation
import Combine

class SearchViewModel {

    var subscriptions: Set<AnyCancellable> = []
    
    func search(with query: String, _ completion: @escaping ([UserModel]) -> Void) {
        DatabaseManager.shared.collectionUsers(search: query)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { users in
                completion(users)
            }
            .store(in: &subscriptions)
    }
}


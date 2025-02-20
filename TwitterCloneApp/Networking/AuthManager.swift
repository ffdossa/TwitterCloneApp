//
//  AuthManager.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import FirebaseAuth
import Combine
import FirebaseAuthCombineSwift

class AuthManager {
    nonisolated(unsafe) static let shared = AuthManager()

    func createUser(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func logInUser(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}


//
//  AuthViewViewModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

final class AuthViewViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthFormValidate: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []

    func validateAuthForm() {
        guard let email = email,
              let password = password else {
            isAuthFormValidate = false
            return
        }
        isAuthFormValidate = isValidateEmail(email) && password.count >= 8
    }
    
    func isValidateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func createUser() {
        guard let email = email,
              let password = password else { return }
        AuthManager.shared.createUser(withEmail: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)
    }
    
    func createRecord(for user: User) {
        DatabaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] complation in
                if case .failure(let error) = complation {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("ADD USER RECORD IN DATABASE \(state)")
            }
            .store(in: &subscriptions)

    }
    
    func logInUser() {
        guard let email = email,
              let password = password else { return }
        AuthManager.shared.logInUser(withEmail: email, password: password)
            .sink { [weak self] completion in
                
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
}

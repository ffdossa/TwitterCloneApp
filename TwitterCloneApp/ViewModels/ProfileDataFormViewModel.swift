//
//  ProfileDataFormViewViewModel.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Foundation
import Combine
import FirebaseAuth
import FirebaseStorage

final class ProfileDataFormViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var displayName: String?
    @Published var userName: String?
    @Published var bio: String?
    @Published var location: String?
    @Published var link: String?
    @Published var birthDate: String?
    @Published var profileImage: String?
    @Published var imageData: UIImage?
    @Published var isFormValidation: Bool = false
    @Published var error: String = ""
    @Published var url: URL?
    @Published var isOnboardingFinished: Bool = false
    
    func validationUserProfileForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let userName = userName,
              userName.count > 2,
              let bio = bio,
              bio.count > 2,
              let location = location,
              location.count > 2,
              let link = link,
              link.count > 2,
              let birthDate = birthDate,
              birthDate.count > 2,
              imageData != nil else {
            isFormValidation = false
            return
        }
        isFormValidation = true
    }
    
    func uploadProfilePhoto() {
        let randomID = UUID().uuidString
        
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                case .finished:
                    self?.updateUserData()
                }
            } receiveValue: { [weak self] url in
                self?.profileImage = url.absoluteString
            }
            .store(in: &subscriptions)
        
    }
    
    private func updateUserData() {
        guard let displayName,
              let userName,
              let bio,
              let location,
              let link,
              let birthDate,
              let profileImage,
              let id = Auth.auth().currentUser?.uid else { return }
        
        let updateFields: [String: Any] = [
            "displayName": displayName,
            "userName": userName,
            "bio": bio,
            "location": location,
            "link": link,
            "birthDate": birthDate,
            "profileImage": profileImage,
            "isUserOnboarded": true
        ]
        DatabaseManager.shared.collectionUsers(updateFields: updateFields, for: id)
            .sink { [weak self] comletion in
                if case .failure(let error) = comletion {
                    print(error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] onboardingState in
                self?.isOnboardingFinished = onboardingState
            }
            .store(in: &subscriptions)
    }
}

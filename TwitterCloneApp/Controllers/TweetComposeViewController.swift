//
//  TweetComposeViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Firebase
import Combine
import Foundation

class TweetComposeViewController: UIViewController {
    
    private var viewModel = TweetComposeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private var profileImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.systemIndigo
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let tweetTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.textContainer.maximumNumberOfLines = 24
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor.systemIndigo
//        textView.attributedText = NSAttributedString(string: "What's happening?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        return textView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(profileImageImageView, tweetTextView, postButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapToCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.systemIndigo
        
        let post = UIBarButtonItem(customView: postButton)
        navigationItem.rightBarButtonItem = post
        postButton.addTarget(self, action: #selector(didTapToPost), for: .touchUpInside)
        
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        addConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileImageImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            profileImageImageView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            profileImageImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageImageView.heightAnchor.constraint(equalToConstant: 40),
            
            tweetTextView.topAnchor.constraint(equalTo: profileImageImageView.topAnchor, constant: 2),
            tweetTextView.leadingAnchor.constraint(equalTo: profileImageImageView.trailingAnchor),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tweetTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -4),
            
            postButton.heightAnchor.constraint(equalToConstant: 32),
            postButton.widthAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func bindViews() {
        viewModel.$isValidateToTweet.sink { [weak self] state in
            self?.postButton.isEnabled = state
        }
        .store(in: &subscriptions)
        
        viewModel.$shouldDismissCompose.sink { [weak self]success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    @objc func didTapToCancel() {
        dismiss(animated: true)
        
    }
    
    @objc func didTapToPost() {
        viewModel.dispatchTweet()
    }
}

extension TweetComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.textColor = .systemIndigo
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = .secondaryLabel
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}

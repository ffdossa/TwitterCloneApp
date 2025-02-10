//
//  WelcomeViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Welcome\nto\nffdossa app"
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 16
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.systemIndigo, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemIndigo
        
        view.addSubviews(welcomeLabel, signUpButton, logInButton)
        addConstraints()
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
             
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            logInButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 48),
            
            signUpButton.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -8),
            signUpButton.leadingAnchor.constraint(equalTo: logInButton.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48)
            ])
    }
    
    @objc func didTapSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapLogIn() {
        let vc = LogInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

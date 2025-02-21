//
//  WelcomeViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

class StartingViewController: UIViewController {

    private let titleLabel = UILabel(title: "Welcome\nto\nffdossa app",
                                       textAlignment: .center)

    private let signUpButton = UIButton(title: "Sign up",
                                        tintColor: .white,
                                        backgroundColor: .clear)

    private let logInButton = UIButton(title: "Log in",
                                       tintColor: .systemIndigo,
                                       backgroundColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemIndigo

        view.addSubviews(titleLabel,
                         signUpButton,
                         logInButton)
        addConstraints()

        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),

            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            logInButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, constant: -16),
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

//
//  LogInViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Combine

class LogInViewController: UIViewController {

    private var viewModel = AuthViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let titleLabel = UILabel(title: "Welcome back.",
                                     textAlignment: .left)

    private let subtitleLabel = UILabel(title: "Please enter your email & password to log in.")

    private lazy var emailTextField = UITextField(title: "Email",
                                                 textContentType: .emailAddress,
                                                 returnKeyType: .next)

    private lazy var passwordTextField = UITextField(title: "Password",
                                                    textContentType: .password,
                                                    returnKeyType: .done)

    private let logInButton = UIButton(title: "Start",
                                       tintColor: .systemIndigo,
                                       backgroundColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo

        passwordTextField.setSecureTextEntry(true)
        logInButton.setEnabled(false)

        view.addSubviews(titleLabel,
                         subtitleLabel,
                         emailTextField,
                         passwordTextField,
                         logInButton)

        addConstraints()
        bindViews()
        logInButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
    }
    
    @objc private func didTapLogIn() {
        viewModel.logInUser()
    }
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didChangeEmailField() {
        viewModel.email = emailTextField.text
        viewModel.validateAuthForm()
    }
    
    @objc private func didChangePasswordField() {
        viewModel.password = passwordTextField.text
        viewModel.validateAuthForm()
    }
    
    private func bindViews() {
        emailTextField.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        viewModel.$isAuthFormValidate.sink { [weak self] validationState in
            self?.logInButton.isEnabled = validationState
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            guard let vc = self?.navigationController?.viewControllers.first as? StartingViewController else { return }
            vc.dismiss(animated: true)
        }
        .store(in: &subscriptions)
        
        viewModel.$error.sink { [weak self] errorString in
            guard let error = errorString else { return }
            self?.errorAlert(with: error)
        }
        .store(in: &subscriptions)
    }
    
    private func errorAlert(with error: String) {
        let alert = UIAlertController(title: "Oops",  message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alert, animated: true)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 144),
            emailTextField.leadingAnchor.constraint(equalTo: logInButton.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            logInButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

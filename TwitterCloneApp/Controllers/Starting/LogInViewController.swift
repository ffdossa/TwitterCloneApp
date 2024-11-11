//
//  LogInViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Combine

class LogInViewController: UIViewController {
    
    private var viewModel = AuthViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Welcome back."
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Please enter your email & password to log in."
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.textAlignment = .center
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor.systemIndigo
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray2])
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.layer.cornerRadius = 16
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor.systemIndigo
        textField.returnKeyType = .done
        return textField
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.tintColor = .systemIndigo
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        view.addSubviews(welcomeLabel, textLabel, emailTextField, passwordTextField, logInButton)
        
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
            guard let vc = self?.navigationController?.viewControllers.first as? WelcomeViewController else { return }
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
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 144),
            
            textLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 24),
            
            emailTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 144),
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

//
//  ProfileDataFormViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFormViewController: UIViewController {
    
    private var viewModel = ProfileDataFormViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemIndigo
        return imageView
    }()
    
    private let borderProfileImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.systemIndigo
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = CGColor(gray: 1, alpha: 0)
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var profileImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 31
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bio"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Website"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Birth date"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let displayNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "Add your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = UIColor.systemIndigo
        return textField
    }()
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "Add your username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = UIColor.systemIndigo
        return textField
    }()
    
    private let bioTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "Add a bio to your profile", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = UIColor.systemIndigo
        return textField
    }()
    
    //    private let bioTextView: UITextView = {
    //        let textView = UITextView()
    //        textView.translatesAutoresizingMaskIntoConstraints = false
    //        textView.keyboardType = .default
    //        textView.layer.masksToBounds = true
    //        textView.textContainer.maximumNumberOfLines = 4
    //        textView.font = .systemFont(ofSize: 14, weight: .regular)
    //        textView.text = "Add a bio to your profile"
    //        textView.textColor = .secondaryLabel
    //        return textView
    //    }()
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "Add your location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = UIColor.systemIndigo
        return textField
    }()
    
    private let websiteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "Add your website", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = UIColor.systemIndigo
        return textField
    }()
    
    private let birthDateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(string: "Add your date of birth", attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        textField.textColor = UIColor.systemIndigo
        return textField
    }()
    
    private let sumbitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("Sumbit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        isModalInPresentation = true
        view.addSubviews(scrollView)
        scrollView.addSubviews(profileHeaderImageView, borderProfileImageImageView, profileImageImageView,  displayNameLabel, userNameLabel, bioLabel, locationLabel, websiteLabel, birthDateLabel, displayNameTextField, userNameTextField, bioTextField, locationTextField, websiteTextField, birthDateTextField, sumbitButton)
        addConstraints()
        bindsViews()
        createDatePicker()
        
        displayNameTextField.delegate = self
        userNameTextField.delegate = self
        bioTextField.delegate = self
        locationTextField.delegate = self
        websiteTextField.delegate = self
        birthDateTextField.delegate = self
        
        sumbitButton.addTarget(self, action: #selector(didTapSumbit), for: .touchUpInside)
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        profileImageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToUpload)))
    }
    
    @objc private func didTapSumbit() {
        viewModel.uploadProfilePhoto()
    }
    
    @objc private func didTapToDismiss() {
        view.endEditing(true)
    }
    
    @objc private func didTapToUpload() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didUpdateDisplayName() {
        viewModel.displayName = displayNameTextField.text
        viewModel.validationUserProfileForm()
    }
    
    @objc private func didUploudUserName() {
        viewModel.userName = userNameTextField.text
        viewModel.validationUserProfileForm()
    }
    
    @objc private func didUpdateBio() {
        viewModel.bio = bioTextField.text
        viewModel.validationUserProfileForm()
    }
    
    @objc private func didUpdateLocation() {
        viewModel.location = locationTextField.text
        viewModel.validationUserProfileForm()
    }
    
    @objc private func didUpdateWebsite() {
        viewModel.link = websiteTextField.text
        viewModel.validationUserProfileForm()
    }
    
    @objc private func didUpdateBirthDate() {
        viewModel.birthDate = birthDateTextField.text
        viewModel.validationUserProfileForm()
    }
    
    @objc func didDonePressed() {
        let datePicker = birthDateTextField.inputView as! UIDatePicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM d"
        birthDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    private func createDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemIndigo
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDonePressed))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        birthDateTextField.inputView = datePicker
        birthDateTextField.inputAccessoryView = toolbar
    }
    
    private func bindsViews() {
        displayNameTextField.addTarget(self, action: #selector(didUpdateDisplayName), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(didUploudUserName), for: .editingChanged)
        bioTextField.addTarget(self, action: #selector(didUpdateBio), for: .editingChanged)
        locationTextField.addTarget(self, action: #selector(didUpdateLocation), for: .editingChanged)
        websiteTextField.addTarget(self, action: #selector(didUpdateWebsite), for: .editingChanged)
        birthDateTextField.addTarget(self, action: #selector(didUpdateBirthDate), for: .editingChanged)
        
        viewModel.$isFormValidation.sink { [weak self] buttonState in
            self?.sumbitButton.isEnabled = buttonState
        }
        .store(in: &subscriptions)
        
        viewModel.$isOnboardingFinished.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileHeaderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -640),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 768),
            
            profileImageImageView.centerXAnchor.constraint(equalTo: borderProfileImageImageView.centerXAnchor),
            profileImageImageView.centerYAnchor.constraint(equalTo: borderProfileImageImageView.centerYAnchor),
            profileImageImageView.widthAnchor.constraint(equalToConstant: 62),
            profileImageImageView.heightAnchor.constraint(equalToConstant: 62),
            
            borderProfileImageImageView.leadingAnchor.constraint(equalTo: profileHeaderImageView.leadingAnchor, constant: 8),
            borderProfileImageImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 8),
            borderProfileImageImageView.widthAnchor.constraint(equalToConstant: 68),
            borderProfileImageImageView.heightAnchor.constraint(equalToConstant: 68),
            
            displayNameLabel.topAnchor.constraint(equalTo: profileImageImageView.bottomAnchor, constant: 24),
            displayNameLabel.leadingAnchor.constraint(equalTo: profileImageImageView.leadingAnchor),
            displayNameLabel.widthAnchor.constraint(equalToConstant: 96),
            
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 24),
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            
            bioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 24),
            bioLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 24),
            locationLabel.leadingAnchor.constraint(equalTo: bioLabel.leadingAnchor),
            
            websiteLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            
            birthDateLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 24),
            birthDateLabel.leadingAnchor.constraint(equalTo: websiteLabel.leadingAnchor),
            
            displayNameTextField.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor),
            displayNameTextField.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor),
            displayNameTextField.trailingAnchor.constraint(equalTo: profileHeaderImageView.trailingAnchor, constant: -8),
            
            userNameTextField.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            userNameTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            userNameTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            
            bioTextField.centerYAnchor.constraint(equalTo: bioLabel.centerYAnchor),
            bioTextField.leadingAnchor.constraint(equalTo: userNameTextField.leadingAnchor),
            bioTextField.trailingAnchor.constraint(equalTo: userNameTextField.trailingAnchor),
            
            locationTextField.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            locationTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            locationTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            
            websiteTextField.centerYAnchor.constraint(equalTo: websiteLabel.centerYAnchor),
            websiteTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            websiteTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            
            birthDateTextField.centerYAnchor.constraint(equalTo: birthDateLabel.centerYAnchor),
            birthDateTextField.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor),
            birthDateTextField.trailingAnchor.constraint(equalTo: displayNameTextField.trailingAnchor),
            
            
            sumbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sumbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sumbitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            sumbitButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

extension ProfileDataFormViewController:UITextFieldDelegate {
    
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - textView.frame.origin.y + 48), animated: true)
    //        if textView.textColor == .secondaryLabel {
    //            textView.textColor = .systemIndigo
    //            textView.text = ""
    //        }
    //    }
    //
    //    func textViewDidEndEditing(_ textView: UITextView) {
    //        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    //        if textView.text.isEmpty {
    //            textView.text = "Add a bio to your profile"
    //            textView.textColor = .secondaryLabel
    //        }
    //    }
    //
    //    func textViewDidChange(_ textView: UITextView) {
    //        viewModel.bio = textView.text
    //        viewModel.validationUserProfileForm()
    //    }
    
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //        let maxCharacters = 150
    //        let currentText = textView.text ?? ""
    //
    //        guard let stringRange = Range(range, in: currentText) else { return false }
    //        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    //
    //        return updatedText.count <= maxCharacters
    //    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharacters = 50
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= maxCharacters
    }
}

extension ProfileDataFormViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.profileImageImageView.image = image
                        self?.viewModel.imageData = image
                        self?.viewModel.validationUserProfileForm()
                    }
                }
            }
        }
    }
}


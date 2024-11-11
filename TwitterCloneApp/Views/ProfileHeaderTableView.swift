//
//  ProfileHeaderTableView.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Combine

class ProfileHeaderTableView: UIView {
    
    private var userCurrentFollowState: ProfileFollowsState = .userCurrentPerson
    var editProfileButtonActionButton: PassthroughSubject<ProfileFollowsState, Never> = PassthroughSubject()
    
    private enum SectionTabs: String {
        case posts = "Posts"
        case replies = "Replies"
        case highlights = "Highlights"
        case media = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self {
            case .posts:
                return 0
            case .replies:
                return 1
            case .highlights:
                return 2
            case .media:
                return 3
            case .likes:
                return 4
            }
        }
    }
    
    lazy var sectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 2
        return view
    }()
    
    private var selectedTab: Int = 0 {
        didSet {
            for i in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.sectionStackView.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in
                    
                }
            }
        }
    }
    
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
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = CGColor(gray: 1, alpha: 0)
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var profileImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    var displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        return label
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var birthDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let joinedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.secondaryLabel
        return imageView
    }()
    
    private let linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "link", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.secondaryLabel
        return imageView
    }()
    
    private let birthDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "balloon.2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.secondaryLabel
        return imageView
    }()
    
    private let joinedDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold))?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.secondaryLabel
        return imageView
    }()
    
    var followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let followingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Following"
        label.textColor = .secondaryLabel
        return label
    }()
    
    var followersCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let followersTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Followers"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var tabs: [UIButton] = ["Posts", "Replies", "Highlights", "Media", "Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubviews(profileHeaderImageView, borderProfileImageImageView, profileImageImageView, editProfileButton, displayNameLabel, userNameLabel, bioLabel, locationImageView, locationLabel, linkImageView, linkLabel, birthDateImageView, birthDateLabel, joinedDateImageView, joinedDateLabel, followingCountLabel, followingTextLabel, followersCountLabel, followersTextLabel, sectionStackView, indicator)
        addConstraints()
        addStackButton()
        setupFollowButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEditProfileButton() {
        editProfileButton.setTitle("Edit profile", for: .normal)
        editProfileButton.backgroundColor = .systemBackground
        editProfileButton.setTitleColor(.systemIndigo, for: .normal)
        editProfileButton.layer.borderColor = UIColor.systemIndigo.cgColor
        userCurrentFollowState = .userCurrentPerson
    }

    func setupFollowButton() {
        editProfileButton.setTitle("Follow", for: .normal)
        editProfileButton.backgroundColor = .systemIndigo
        editProfileButton.setTitleColor(.systemBackground, for: .normal)
        userCurrentFollowState = .userIsUnfollow
    }
    
    func setupFollowingButton() {
        editProfileButton.setTitle("Following", for: .normal)
        editProfileButton.backgroundColor = .systemBackground
        editProfileButton.setTitleColor(.systemIndigo, for: .normal)
        editProfileButton.layer.borderColor = UIColor.systemIndigo.cgColor
        editProfileButton.layer.borderWidth = 1

    }
    
    func setupUnfollowButton() {
        editProfileButton.setTitle("Unfollow", for: .normal)
        editProfileButton.backgroundColor = .systemBackground
        editProfileButton.setTitleColor(.systemIndigo, for: .normal)
        editProfileButton.layer.borderColor = UIColor.systemIndigo.cgColor
        editProfileButton.layer.borderWidth = 1
        userCurrentFollowState = .userIsFollow
    }
    
    private func setupFollowButtonAction() {
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    @objc func didTapEditProfileButton() {
        editProfileButtonActionButton.send(userCurrentFollowState)
    }
    
    private func addStackButton() {
        for (i, button) in sectionStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            
            if i == selectedTab {
                button.tintColor = .label
            } else {
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapTabs(_:)), for: .touchUpInside)
        }
    }
    
    private func addConstraints() {
        for i in 0..<tabs.count {
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAnchor)
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        NSLayoutConstraint.activate([
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor, constant: -640),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 768),
            
            profileImageImageView.centerXAnchor.constraint(equalTo: borderProfileImageImageView.centerXAnchor),
            profileImageImageView.centerYAnchor.constraint(equalTo: borderProfileImageImageView.centerYAnchor),
            profileImageImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageImageView.heightAnchor.constraint(equalToConstant: 60),
            
            borderProfileImageImageView.leadingAnchor.constraint(equalTo: profileHeaderImageView.leadingAnchor, constant: 8),
            borderProfileImageImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 8),
            borderProfileImageImageView.widthAnchor.constraint(equalToConstant: 68),
            borderProfileImageImageView.heightAnchor.constraint(equalToConstant: 68),
            
            editProfileButton.bottomAnchor.constraint(equalTo: profileImageImageView.bottomAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: profileHeaderImageView.trailingAnchor, constant: -8),
            editProfileButton.widthAnchor.constraint(equalToConstant: 112),
            editProfileButton.heightAnchor.constraint(equalToConstant: 32),
            
            
            displayNameLabel.leadingAnchor.constraint(equalTo: profileImageImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileImageImageView.bottomAnchor, constant: 8),
            
            userNameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor),
            
            bioLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 12),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            locationImageView.leadingAnchor.constraint(equalTo: bioLabel.leadingAnchor),
            locationImageView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 12),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 4),
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            
            linkImageView.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 8),
            linkImageView.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            
            linkLabel.leadingAnchor.constraint(equalTo: linkImageView.trailingAnchor, constant: 4),
            linkLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            
            birthDateImageView.leadingAnchor.constraint(equalTo: linkLabel.trailingAnchor, constant: 8),
            birthDateImageView.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            
            birthDateLabel.leadingAnchor.constraint(equalTo: birthDateImageView.trailingAnchor, constant: 4),
            birthDateLabel.centerYAnchor.constraint(equalTo: linkLabel.centerYAnchor),
            birthDateLabel.trailingAnchor.constraint(equalTo: profileHeaderImageView.trailingAnchor, constant: -8),
            
            joinedDateImageView.leadingAnchor.constraint(equalTo: locationImageView.leadingAnchor),
            joinedDateImageView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 12),
            
            joinedDateLabel.leadingAnchor.constraint(equalTo: joinedDateImageView.trailingAnchor, constant: 4),
            joinedDateLabel.centerYAnchor.constraint(equalTo: joinedDateImageView.centerYAnchor),
            
            followingCountLabel.leadingAnchor.constraint(equalTo: joinedDateImageView.leadingAnchor),
            followingCountLabel.topAnchor.constraint(equalTo: joinedDateImageView.bottomAnchor, constant: 12),
            
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 4),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor),
            
            followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor, constant: 8),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingTextLabel.bottomAnchor),
            
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 4),
            followersTextLabel.bottomAnchor.constraint(equalTo: followersCountLabel.bottomAnchor),
            
            sectionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            sectionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sectionStackView.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 8),
            sectionStackView.heightAnchor.constraint(equalToConstant: 32),
            
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStackView.bottomAnchor, constant: -4),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    @objc private func didTapTabs(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.posts.rawValue:
            selectedTab = 0
        case SectionTabs.replies.rawValue:
            selectedTab = 1
        case SectionTabs.highlights.rawValue:
            selectedTab = 2
        case SectionTabs.media.rawValue:
            selectedTab = 3
        case SectionTabs.likes.rawValue:
            selectedTab = 4
        default:
            selectedTab = 0
        }
    }
}

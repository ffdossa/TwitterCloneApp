//
//  SearchUserTableViewCell.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 14.10.2024.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {
    
    static let identifier: String = "SearchUserTableViewCell"
    
    private var profileImageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22
        imageView.image = UIImage(systemName: "camera.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.systemIndigo
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(profileImageImageView, displayNameLabel, usernameLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileImageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profileImageImageView.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            profileImageImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            profileImageImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageImageView.heightAnchor.constraint(equalToConstant: 44),
            
            displayNameLabel.leadingAnchor.constraint(equalTo: profileImageImageView.trailingAnchor, constant: 8),
            displayNameLabel.topAnchor.constraint(equalTo: profileImageImageView.topAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
        ])
    }
    
    func configureUsers(with user: UserModel) {
        profileImageImageView.sd_setImage(with: URL(string: user.profileImage))
        displayNameLabel.text = user.displayName
        usernameLabel.text = "@\(user.userName)"
    }
}

//
//  TweetTableViewCell.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

protocol TweetTableViewCellDelegate: AnyObject {
    func tweetTableViewCellDidTapReply()
    func tweetTableViewCellDidTapRetweet()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapShare()
}

class TweetTableViewCell: UITableViewCell {
    
    weak var delegate: TweetTableViewCellDelegate?
    
    static let identifier = "TweetTableViewCell"
    
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
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tweetTextContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        contentView.addSubviews(profileImageImageView, displayNameLabel, usernameLabel, tweetTextContentLabel, replyButton, retweetButton, likeButton, shareButton)
        addConstraints()
        addButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupTweets(with displayName: String, userName: String, tweetTextContent: String, profileImage: String) {
        displayNameLabel.text = displayName
        usernameLabel.text = "@\(userName)"
        tweetTextContentLabel.text = tweetTextContent
        profileImageImageView.sd_setImage(with: URL(string: profileImage))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileImageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profileImageImageView.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            profileImageImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageImageView.heightAnchor.constraint(equalToConstant: 44),
            
            displayNameLabel.leadingAnchor.constraint(equalTo: profileImageImageView.trailingAnchor, constant: 8),
            displayNameLabel.topAnchor.constraint(equalTo: profileImageImageView.topAnchor),
            
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor),
            
            tweetTextContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetTextContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 8),
            tweetTextContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            replyButton.leadingAnchor.constraint(equalTo: tweetTextContentLabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: tweetTextContentLabel.bottomAnchor, constant: 8),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: 32),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),
            
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: 32),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),
            
            shareButton.trailingAnchor.constraint(equalTo: tweetTextContentLabel.trailingAnchor),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor),
        ])
    }
    
    private func addButtons() {
        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweet), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    @objc private func didTapReply() {
        delegate?.tweetTableViewCellDidTapReply()
    }
    
    @objc private func didTapRetweet() {
        delegate?.tweetTableViewCellDidTapRetweet()
    }
    
    @objc private func didTapLike() {
        delegate?.tweetTableViewCellDidTapLike()
    }
    
    @objc private func didTapShare() {
        delegate?.tweetTableViewCellDidTapShare()
    }
}

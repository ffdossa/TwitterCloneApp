//
//  ProfileViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = true
    private var viewModel: ProfileViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var headerView = ProfileHeaderTableView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 384))
    
    private let statusBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        view.addSubviews(profileTableView, statusBar)
        profileTableView.tableHeaderView = headerView
        profileTableView.contentInsetAdjustmentBehavior = .never
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        profileTableView.delegate = self
        profileTableView.dataSource = self
        addConstraints()
        bindViews()
        viewModel.fetchUserTweets()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 768 ? 64 : 16),
        ])
    }
    
    private func bindViews() {
        viewModel.$tweets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.profileTableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                headerView.profileImageImageView.sd_setImage(with: URL(string: user.profileImage))
                headerView.displayNameLabel.text = user.displayName
                headerView.userNameLabel.text = "@\(user.userName)"
                headerView.bioLabel.text = user.bio
                headerView.locationLabel.text = user.location
                headerView.linkLabel.text = user.link
                headerView.birthDateLabel.text = "Born \(self.viewModel.getFormattedDate(from: user.birthDate))"
                headerView.joinedDateLabel.text = "Joined \(self.viewModel.getFormattedDate(from: user.joinedDate))"
                headerView.followingCountLabel.text = "\(user.followingCount)"
                headerView.followersCountLabel.text = "\(user.followersCount)"
            }
            .store(in: &subscriptions)
        
        viewModel.$currentFollowsState.sink { [weak self] state in
            switch state {
            case .userCurrentPerson:
                self?.headerView.setupEditProfileButton()
            case .userIsFollow:
                self?.headerView.setupUnfollowButton()
            case .userIsUnfollow:
                self?.headerView.setupFollowButton()
            }
        }
        .store(in: &subscriptions)
        
        headerView.editProfileButtonActionButton.sink { [weak self] state in
            switch state {
            case .userIsFollow:
                self?.viewModel.unfollowUser()
            case .userIsUnfollow:
                self?.viewModel.followingUser()
            case .userCurrentPerson:
                return
            }
        }
        .store(in: &subscriptions)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweet = viewModel.tweets[indexPath.row]
        cell.setupTweets(with: tweet.author.displayName,
                             userName: tweet.author.userName,
                             tweetTextContent: tweet.tweetText,
                             profileImage: tweet.author.profileImage)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 128 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: { _ in }
            
        } else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
}

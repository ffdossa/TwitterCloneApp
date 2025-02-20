//
//  HomeViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit
import Combine
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier:TweetTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var composeTweetButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
            self?.navigateToTweetComposer()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        
        let plusSignInImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .medium))
        button.setImage(plusSignInImage, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(timelineTableView, composeTweetButton)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        setupNavigationBar()
        bindViews()
        addConstraints()
    }
    
    private func setupNavigationBar() {
        let size: CGFloat = 26
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitter")?.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = .systemIndigo
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        let profileImage = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
        
        let exitImage = UIImage(systemName: "arrow.right.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: exitImage, style: .plain, target: self, action: #selector(didTapSignOut))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        timelineTableView.frame = view.frame
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: WelcomeViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    
    private func navigateToTweetComposer() {
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser()
    }
    
    func completeUserOnboarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    func bindViews() {
        viewModel.$user.sink { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else { return }
                if !user.isUserOnboarded {
                    self?.completeUserOnboarding()
                }
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 56),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc func didTapProfile() {
        guard let user = viewModel.user else { return }
        let profileViewModel = ProfileViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapSignOut() {
        try? Auth.auth().signOut()
        handleAuthentication()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.setupTweets(with: tweetModel.author.displayName,
                             userName: tweetModel.author.userName,
                             tweetTextContent: tweetModel.tweetText,
                             profileImage: tweetModel.author.profileImage)
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: @preconcurrency TweetTableViewCellDelegate {
    func tweetTableViewCellDidTapReply() {
        print("REPLY")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("RETWEET")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("LIKE")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("SHARE")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


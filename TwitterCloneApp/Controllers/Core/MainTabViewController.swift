//
//  MainTabViewController.swift
//  TwitterCloneApp
//
//  Created by Andrii Marchuk on 11.10.2024.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .systemIndigo
        tabBar.unselectedItemTintColor = .systemGray2
        
        setupTabs()
    }

    func setupTabs() {
        let homeNavigation = UINavigationController(rootViewController: HomeViewController())
        let searchNavigation = UINavigationController(rootViewController: SearchViewController(viewModel: SearchViewModel()))
        let notificationNavigation = UINavigationController(rootViewController: NotificationViewController())
        let directNavigation = UINavigationController(rootViewController: DirectViewController())
        
        homeNavigation.tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        homeNavigation.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysTemplate)
        
        searchNavigation.tabBarItem.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        searchNavigation.tabBarItem.selectedImage = UIImage(systemName: "sparkle.magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        
        notificationNavigation.tabBarItem.image = UIImage(systemName: "bell")?.withRenderingMode(.alwaysTemplate)
        notificationNavigation.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysTemplate)
        
        directNavigation.tabBarItem.image = UIImage(systemName: "envelope")?.withRenderingMode(.alwaysTemplate)
        directNavigation.tabBarItem.selectedImage = UIImage(systemName: "envelope.fill")?.withRenderingMode(.alwaysTemplate)
        
        for navigation in [homeNavigation, searchNavigation, notificationNavigation, directNavigation] {
            navigation.navigationBar.tintColor = .systemIndigo
        }
        
        setViewControllers([homeNavigation, searchNavigation, notificationNavigation, directNavigation], animated: true)
    }
}

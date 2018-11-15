//
//  MenuTabBarController.swift
//  GitHub
//
//  Created by Vadim on 11/3/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController {
        
    let profileViewController = ProfileViewController()
    let searchViewController = SearchViewController()
    let bookmarksViewController = BookmarkViewController()
    let userRepositoriesViewController = UserRepositoriesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileViewController.setupViewController(title: "Profile", tabBarImageName: "profile", tag: 0)
        searchViewController.setupViewController(title: "Search", tabBarImageName: "search", tag: 1)
        bookmarksViewController.setupViewController(title: "Bookmarks", tabBarImageName: "bookmark", tag: 2)
        userRepositoriesViewController.setupViewController(title: "My repositories", tabBarImageName: "repo", tag: 3)
        
        viewControllers = [profileViewController, searchViewController, bookmarksViewController, userRepositoriesViewController].map {
            UINavigationController(rootViewController: $0)
        }
    }
}
